#include "script_component.hpp"
/*
 * Author: mharis001
 * Initializes the VECTOR content control.
 *
 * Arguments:
 * 0: Controls Group <CONTROL>
 * 1: Default Value <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL, [0, 0, 0]] call zen_dialog_fnc_gui_vector
 *
 * Public: No
 */

params ["_controlsGroup", "_defaultValue"];

// Only allow numeric characters to be entered
private _fnc_textChanged = {
    params ["_ctrlEdit"];

    private _filter = toArray ".-0123456789";
    private _text = toString (toArray ctrlText _ctrlEdit select {_x in _filter});
    _ctrlEdit ctrlSetText _text;
};

private _controls = [];

{
    private _ctrlEdit = _controlsGroup controlsGroupCtrl (IDCS_ROW_VECTOR select _forEachIndex);
    _ctrlEdit ctrlAddEventHandler ["KeyDown", _fnc_textChanged];
    _ctrlEdit ctrlAddEventHandler ["KeyUp", _fnc_textChanged];
    _ctrlEdit ctrlSetText str _x;

    _controls pushBack _ctrlEdit;
} forEach _defaultValue;

_controlsGroup setVariable [QGVAR(controls), _controls];

_controlsGroup setVariable [QFUNC(value), {
    params ["_controlsGroup"];

    private _controls = _controlsGroup getVariable QGVAR(controls);
    _controls apply {parseNumber ctrlText _x}
}];
