import 'package:flutter/material.dart';
import 'package:z_editor/data/level_parser.dart';
import 'package:z_editor/data/plant_repository.dart';
import 'package:z_editor/data/pvz_models.dart';
import 'package:z_editor/data/rtid_parser.dart';
import 'package:z_editor/theme/app_theme.dart';
import 'package:z_editor/l10n/app_localizations.dart';
import 'package:z_editor/l10n/resource_names.dart';
import 'package:z_editor/screens/select/plant_selection_screen.dart';
import 'package:z_editor/widgets/asset_image.dart' show AssetImageWidget, imageAltCandidates;
import 'package:z_editor/widgets/editor_components.dart';

/// Legacy preset plants (frozen plant placement). Ported from Z-Editor-master InitialPlantPropertiesEP.kt
class InitialPlantPropertiesScreen extends StatefulWidget {
  const InitialPlantPropertiesScreen({
    super.key,
    required this.rtid,
    required this.levelFile,
    required this.onChanged,
    required this.onBack,
  });

  final String rtid;
  final PvzLevelFile levelFile;
  final VoidCallback onChanged;
  final VoidCallback onBack;

  @override
  State<InitialPlantPropertiesScreen> createState() =>
      _InitialPlantPropertiesScreenState();
}

class _InitialPlantPropertiesScreenState extends State<InitialPlantPropertiesScreen> {
  late PvzObject _moduleObj;
  late InitialPlantPropertiesData _data;
  int _selectedX = 0;
  int _selectedY = 0;
  InitialPlantPlacementData? _editingPlacement;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final info = RtidParser.parse(widget.rtid);
    final alias = info?.alias ?? '';
    _moduleObj = widget.levelFile.objects.firstWhere(
      (o) => o.aliases?.contains(alias) == true,
      orElse: () => PvzObject(
        aliases: [alias],
        objClass: 'InitialPlantProperties',
        objData: InitialPlantPropertiesData().toJson(),
      ),
    );
    if (!widget.levelFile.objects.contains(_moduleObj)) {
      widget.levelFile.objects.add(_moduleObj);
    }
    try {
      _data = InitialPlantPropertiesData.fromJson(
        Map<String, dynamic>.from(_moduleObj.objData as Map),
      );
    } catch (_) {
      _data = InitialPlantPropertiesData();
    }
    _data = InitialPlantPropertiesData(
      placements: List.from(_data.placements),
      isInitialIntensiveCarrotPlacements: _data.isInitialIntensiveCarrotPlacements,
    );
  }

  void _sync() {
    _moduleObj.objData = _data.toJson();
    widget.onChanged();
    setState(() {});
  }

  void _handleSelectPlant() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlantSelectionScreen(
          isMultiSelect: false,
          onPlantSelected: (id) {
            Navigator.pop(context);
            final newList = List<InitialPlantPlacementData>.from(_data.placements);
            newList.add(InitialPlantPlacementData(
              gridX: _selectedX,
              gridY: _selectedY,
              typeName: id,
              level: 1,
              condition: null,
            ));
            _data = InitialPlantPropertiesData(
              placements: newList,
              isInitialIntensiveCarrotPlacements:
                  _data.isInitialIntensiveCarrotPlacements,
            );
            _sync();
          },
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _updatePlacement(
    InitialPlantPlacementData oldPlacement,
    InitialPlantPlacementData newPlacement,
  ) {
    final newList = List<InitialPlantPlacementData>.from(_data.placements);
    final idx = newList.indexOf(oldPlacement);
    if (idx >= 0) {
      newList[idx] = newPlacement;
      _data = InitialPlantPropertiesData(
        placements: newList,
        isInitialIntensiveCarrotPlacements:
            _data.isInitialIntensiveCarrotPlacements,
      );
      _sync();
    }
  }

  void _deletePlacement(InitialPlantPlacementData target) {
    final newList = List<InitialPlantPlacementData>.from(_data.placements);
    newList.remove(target);
    _data = InitialPlantPropertiesData(
      placements: newList,
      isInitialIntensiveCarrotPlacements:
          _data.isInitialIntensiveCarrotPlacements,
    );
    _sync();
  }

  bool get _isDeepSeaLawn {
    final parsed = LevelParser.parseLevel(widget.levelFile);
    return LevelParser.isDeepSeaLawn(parsed.levelDef);
  }

  int get _gridRows => _isDeepSeaLawn ? 6 : 5;
  int get _gridCols => _isDeepSeaLawn ? 10 : 9;

  void _showHelp() {
    final l10n = AppLocalizations.of(context)!;
    showEditorHelpDialog(
      context,
      title: l10n.frozenPlantPlacementHelpTitle,
      themeColor: Theme.of(context).brightness == Brightness.dark
          ? pvzGreenDark
          : pvzGreenLight,
      sections: [
        HelpSectionData(
          title: l10n.frozenPlantPlacementHelpOverviewTitle,
          body: l10n.frozenPlantPlacementHelpOverviewBody,
        ),
        HelpSectionData(
          title: l10n.frozenPlantPlacementHelpConditionTitle,
          body: l10n.frozenPlantPlacementHelpConditionBody,
        ),
        HelpSectionData(
          title: l10n.frozenPlantPlacementHelpLastStandTitle,
          body: l10n.frozenPlantPlacementHelpLastStandBody,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final barColor = isDark ? pvzGreenDark : pvzGreenLight;
    final sortedPlacements = List<InitialPlantPlacementData>.from(_data.placements)
      ..sort((a, b) {
        final c = a.gridY.compareTo(b.gridY);
        return c != 0 ? c : a.gridX.compareTo(b.gridX);
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.frozenPlantPlacementTitle),
        backgroundColor: barColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: SwitchListTile(
                    title: Text(
                      l10n.frozenPlantPlacementLastStand,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'IsInitialIntensiveCarrotPlacements',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: _data.isInitialIntensiveCarrotPlacements == true,
                    onChanged: (v) {
                      _data = InitialPlantPropertiesData(
                        placements: _data.placements,
                        isInitialIntensiveCarrotPlacements: v ? true : null,
                      );
                      _sync();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.frozenPlantPlacementSelectedPosition,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  'R${_selectedY + 1} : C${_selectedX + 1}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            FilledButton.icon(
                              onPressed: _handleSelectPlant,
                              icon: const Icon(Icons.add, size: 18),
                              label: Text(l10n.frozenPlantPlacementPlaceHere),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildGrid(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.frozenPlantPlacementPlantList,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                ...sortedPlacements.map((p) => _PlacementCard(
                      placement: p,
                      gridRows: _gridRows,
                      gridCols: _gridCols,
                      isSelected:
                          p.gridX == _selectedX && p.gridY == _selectedY,
                      onTap: () {
                        setState(() {
                          _selectedX = p.gridX;
                          _selectedY = p.gridY;
                          _editingPlacement = p;
                        });
                      },
                    )),
              ],
            ),
          ),
          if (_editingPlacement != null) _buildEditDialog(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final theme = Theme.of(context);
    final rows = _gridRows;
    final cols = _gridCols;
    return scaleTableForDesktop(
      context: context,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: AspectRatio(
          aspectRatio: cols / rows,
          child: Container(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF3C483D)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
            ),
            child: Column(
              children: List.generate(rows, (row) {
                return Expanded(
                  child: Row(
                    children: List.generate(cols, (col) {
                      final isSelected =
                          row == _selectedY && col == _selectedX;
                      final cellPlacements = _data.placements
                          .where((p) => p.gridX == col && p.gridY == row)
                          .toList();
                      final firstPlacement =
                          cellPlacements.isNotEmpty ? cellPlacements.first : null;
                      final count = cellPlacements.length;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _selectedX = col;
                            _selectedY = row;
                          }),
                          child: Container(
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withValues(
                                      alpha: 0.2,
                                    )
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : const Color(0xFFA5D6A7),
                                width: 0.5,
                              ),
                            ),
                            child: count > 0 && firstPlacement != null
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: _PlantIconSmall(
                                                firstPlacement.typeName),
                                          ),
                                        ),
                                      ),
                                      if (count > 1)
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(
                                                alpha: 0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '+${count - 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditDialog() {
    final placement = _editingPlacement!;
    return _PlacementEditDialog(
      placement: placement,
      onSave: (updated) {
        _updatePlacement(placement, updated);
        setState(() => _editingPlacement = null);
      },
      onDelete: () {
        _deletePlacement(placement);
        setState(() => _editingPlacement = null);
      },
      onCancel: () => setState(() => _editingPlacement = null),
    );
  }
}

class _PlantIconSmall extends StatelessWidget {
  const _PlantIconSmall(this.plantType);

  final String plantType;

  @override
  Widget build(BuildContext context) {
    final info = PlantRepository().getPlantInfoById(plantType);
    final path = info?.icon != null
        ? 'assets/images/plants/${info!.icon}'
        : 'assets/images/others/unknown.webp';
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AssetImageWidget(
        assetPath: path,
        fit: BoxFit.cover,
        width: 32,
        height: 32,
        altCandidates: imageAltCandidates(path),
      ),
    );
  }
}

class _PlacementCard extends StatelessWidget {
  const _PlacementCard({
    required this.placement,
    required this.gridRows,
    required this.gridCols,
    required this.isSelected,
    required this.onTap,
  });

  final InitialPlantPlacementData placement;
  final int gridRows;
  final int gridCols;
  final bool isSelected;
  final VoidCallback onTap;

  bool get _isOutOfBounds =>
      placement.gridX >= gridCols || placement.gridY >= gridRows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final info = PlantRepository().getPlantInfoById(placement.typeName);
    final plantName = ResourceNames.lookup(
      context,
      PlantRepository().getName(placement.typeName),
    );
    final path = info?.icon != null
        ? 'assets/images/plants/${info!.icon}'
        : 'assets/images/others/unknown.webp';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected
          ? (theme.brightness == Brightness.dark
              ? const Color(0xFF3C483D)
              : const Color(0xFFD5F3D6))
          : theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 1)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (_isOutOfBounds)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber.shade700,
                    size: 24,
                  ),
                ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AssetImageWidget(
                  assetPath: path,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  altCandidates: imageAltCandidates(path),
                  errorWidget: Container(
                    color: theme.colorScheme.onSurfaceVariant,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$plantName (R${placement.gridY + 1}:C${placement.gridX + 1})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    Text(
                      placement.condition ?? l10n.noConditions,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlacementEditDialog extends StatefulWidget {
  const _PlacementEditDialog({
    required this.placement,
    required this.onSave,
    required this.onDelete,
    required this.onCancel,
  });

  final InitialPlantPlacementData placement;
  final void Function(InitialPlantPlacementData) onSave;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  @override
  State<_PlacementEditDialog> createState() => _PlacementEditDialogState();
}

class _PlacementEditDialogState extends State<_PlacementEditDialog> {
  late int _level;
  late String? _condition;

  @override
  void initState() {
    super.initState();
    _level = widget.placement.level;
    _condition = widget.placement.condition;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = ResourceNames.lookup(
      context,
      PlantRepository().getName(widget.placement.typeName),
    );
    return AlertDialog(
      title: Text(l10n.frozenPlantPlacementEditPlant(name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${l10n.frozenPlantPlacementLevel}: $_level',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _level.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (v) => setState(() => _level = v.round()),
          ),
          const Divider(),
          DropdownButtonFormField<String?>(
            initialValue: _condition,
            decoration: InputDecoration(
              labelText: l10n.frozenPlantPlacementCondition,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(l10n.frozenPlantPlacementConditionNull),
              ),
              const DropdownMenuItem<String?>(
                value: 'icecubed',
                child: Text('icecubed'),
              ),
            ],
            onChanged: (v) => setState(() => _condition = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onDelete,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(l10n.delete),
        ),
        TextButton(
          onPressed: widget.onCancel,
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(InitialPlantPlacementData(
              gridX: widget.placement.gridX,
              gridY: widget.placement.gridY,
              typeName: widget.placement.typeName,
              level: _level,
              condition: _condition,
            ));
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
