//! System Tray (SDL_tray.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// An opaque handle representing a toplevel system tray object.
pub const Tray = opaque {
    pub const create = createTray;
    pub const setIcon = setTrayIcon;
    pub const setTooltip = setTrayTooltip;
    pub const createMenu = createTrayMenu;
    pub const getMenu = getTrayMenu;
    pub const destroy = destroyTray;
    pub const getMenuParentTray = getTrayMenuParentTray;
};

/// An opaque handle representing a menu/submenu on a system tray object.
pub const TrayMenu = opaque {
    pub const create = createTrayMenu;
    pub const get = getTrayMenu;
    pub const getParentEntry = getTrayMenuParentEntry;
    pub const getParentTray = getTrayMenuParentTray;
};

/// An opaque handle representing an entry on a system tray object.
pub const TrayEntry = opaque {
    pub const remove = removeTrayEntry;
    pub const insertAt = insertTrayEntryAt;
    pub const setLabel = setTrayEntryLabel;
    pub const getLabel = getTrayEntryLabel;
    pub const setChecked = setTrayEntryChecked;
    pub const getChecked = getTrayEntryChecked;
    pub const setEnabled = setTrayEntryEnabled;
    pub const getEnabled = getTrayEntryEnabled;
    pub const setCallback = setTrayEntryCallback;
    pub const click = clickTrayEntry;
    pub const getParent = getTrayEntryParent;
};

/// Flags that control the creation of system tray entries.
///
/// Some of these flags are required; exactly one of them must be specified at
/// the time a tray entry is created. Other flags are optional; zero or more of
/// those can be OR'ed together with the required flag.
pub const TrayEntryFlags = packed struct(u32) {
    /// Make the entry a simple button. Required.
    button: bool = false,
    /// Make the entry a checkbox. Required.
    checkbox: bool = false,
    /// Prepare the entry to have a submenu. Required
    submenu: bool = false,
    __unused3: u27 = 0,
    /// Make the entry checked. This is valid only for checkboxes. Optional.
    checked: bool = false,
    /// Make the entry disabled. Optional.
    disabled: bool = false,
};

/// A callback that is invoked when a tray entry is selected.
pub const TrayCallback = *const fn (userdata: ?*anyopaque, entry: *TrayEntry) callconv(.c) void;

/// Create an icon to be placed in the operating system's tray, or equivalent.
///
/// Many platforms advise not using a system tray unless persistence is a
/// necessary feature. Avoid needlessly creating a tray icon, as the user may
/// feel like it clutters their interface.
///
/// Using tray icons require the video subsystem.
pub fn createTray(icon: ?*sdl.Surface, tooltip: ?[:0]const u8) Error!*Tray {
    return SDL_CreateTray(icon, if (tooltip) |s| s.ptr else null) orelse makeError();
}
extern fn SDL_CreateTray(icon: ?*sdl.Surface, tooltip: ?[*:0]const u8) ?*Tray;

/// Updates the system tray icon's icon.
pub const setTrayIcon = SDL_SetTrayIcon;
extern fn SDL_SetTrayIcon(tray: *Tray, icon: ?*sdl.Surface) void;

/// Updates the system tray icon's tooltip.
pub fn setTrayTooltip(tray: *Tray, tooltip: ?[:0]const u8) void {
    return SDL_SetTrayTooltip(tray, if (tooltip) |s| s.ptr else null);
}
extern fn SDL_SetTrayTooltip(tray: *Tray, tooltip: ?[*:0]const u8) void;

/// Create a menu for a system tray.
///
/// This should be called at most once per tray icon.
///
/// This function does the same thing as `createTraySubmenu`, except that
/// it takes a `Tray` instead of a `TrayEntry`.
///
/// A menu does not need to be destroyed; it will be destroyed with the tray.
pub fn createTrayMenu(tray: *Tray) Error!*TrayMenu {
    return SDL_CreateTrayMenu(tray) orelse makeError();
}
extern fn SDL_CreateTrayMenu(tray: *Tray) ?*TrayMenu;

/// Create a submenu for a system tray entry.
///
/// This should be called at most once per tray entry.
///
/// This function does the same thing as `createTrayMenu`, except that it
/// takes a `TrayEntry` instead of a `Tray`.
///
/// A menu does not need to be destroyed; it will be destroyed with the tray.
pub fn createTraySubmenu(entry: *TrayEntry) Error!*TrayMenu {
    return SDL_CreateTraySubmenu(entry) orelse makeError();
}
extern fn SDL_CreateTraySubmenu(entry: *TrayEntry) ?*TrayMenu;

/// Gets a previously created tray menu.
///
/// You should have called `createTrayMenu` on the tray object. This
/// function allows you to fetch it again later.
///
/// This function does the same thing as `getTraySubmenu`, except that it
/// takes a `Tray` instead of a `TrayEntry`.
///
/// A menu does not need to be destroyed; it will be destroyed with the tray.
pub const getTrayMenu = SDL_GetTrayMenu;
extern fn SDL_GetTrayMenu(tray: *Tray) ?*TrayMenu;

/// Gets a previously created tray entry submenu.
///
/// You should have called `createTraySubmenu` on the entry object. This
/// function allows you to fetch it again later.
///
/// This function does the same thing as `getTrayMenu`, except that it
/// takes a `TrayEntry` instead of a `Tray`.
///
/// A menu does not need to be destroyed; it will be destroyed with the tray.
pub const getTraySubmenu = SDL_GetTraySubmenu;
extern fn SDL_GetTraySubmenu(entry: *TrayEntry) ?*TrayMenu;

/// Returns a list of entries in the menu, in order.
pub fn getTrayEntries(menu: *TrayMenu) []*const TrayEntry {
    var count: c_int = undefined;
    const ptr = SDL_GetTrayEntries(menu, &count) orelse return &.{};
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetTrayEntries(menu: *TrayMenu, count: ?*c_int) ?[*]*const TrayEntry;

/// Removes a tray entry.
pub const removeTrayEntry = SDL_RemoveTrayEntry;
extern fn SDL_RemoveTrayEntry(entry: *TrayEntry) void;

/// Insert a tray entry at a given position.
///
/// If label is null, the entry will be a separator. Many functions won't work
/// for an entry that is a separator.
///
/// An entry does not need to be destroyed; it will be destroyed with the tray.
///
/// Returns an error if `pos` is out of bounds.
pub fn insertTrayEntryAt(menu: *TrayMenu, pos: c_int, label: ?[:0]const u8, flags: TrayEntryFlags) Error!*TrayEntry {
    return SDL_InsertTrayEntryAt(menu, pos, if (label) |s| s.ptr else null, flags) orelse makeError();
}
extern fn SDL_InsertTrayEntryAt(menu: *TrayMenu, pos: c_int, label: ?[*:0]const u8, flags: TrayEntryFlags) ?*TrayEntry;

/// Sets the label of an entry.
///
/// An entry cannot change between a separator and an ordinary entry; that is,
/// it is not possible to set a non-null label on an entry that has a null
/// label (separators), or to set a null label to an entry that has a non-null
/// label. The function will silently fail if that happens.
pub fn setTrayEntryLabel(entry: *TrayEntry, label: [:0]const u8) void {
    return SDL_SetTrayEntryLabel(entry, label.ptr);
}
extern fn SDL_SetTrayEntryLabel(entry: *TrayEntry, label: [*:0]const u8) void;

/// Gets the label of an entry.
///
/// If the returned value is null, the entry is a separator.
///
/// Returns null for entries without a label, such as separators.
pub fn getTrayEntryLabel(entry: *TrayEntry) ?[:0]const u8 {
    const str = SDL_GetTrayEntryLabel(entry) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetTrayEntryLabel(entry: *TrayEntry) ?[*:0]const u8;

/// Sets whether or not an entry is checked.
///
/// The entry must have been created with the `TrayEntryFlags.checkbox` flag.
pub const setTrayEntryChecked = SDL_SetTrayEntryChecked;
extern fn SDL_SetTrayEntryChecked(entry: *TrayEntry, checked: bool) void;

/// Gets whether or not an entry is checked.
///
/// The entry must have been created with the `TrayEntryFlags.checkbox` flag.
pub const getTrayEntryChecked = SDL_GetTrayEntryChecked;
extern fn SDL_GetTrayEntryChecked(entry: *TrayEntry) bool;

/// Sets whether or not an entry is enabled.
pub const setTrayEntryEnabled = SDL_SetTrayEntryEnabled;
extern fn SDL_SetTrayEntryEnabled(entry: *TrayEntry, enabled: bool) void;

/// Gets whether or not an entry is enabled.
pub const getTrayEntryEnabled = SDL_GetTrayEntryEnabled;
extern fn SDL_GetTrayEntryEnabled(entry: *TrayEntry) bool;

/// Sets a callback to be invoked when the entry is selected.
pub const setTrayEntryCallback = SDL_SetTrayEntryCallback;
extern fn SDL_SetTrayEntryCallback(entry: *TrayEntry, callback: ?TrayCallback, userdata: ?*anyopaque) void;

/// Simulate a click on a tray entry.
pub const clickTrayEntry = SDL_ClickTrayEntry;
extern fn SDL_ClickTrayEntry(entry: *TrayEntry) void;

/// Destroys a tray object.
///
/// This also destroys all associated menus and entries.
pub const destroyTray = SDL_DestroyTray;
extern fn SDL_DestroyTray(tray: *Tray) void;

/// Gets the menu containing a certain tray entry.
pub const getTrayEntryParent = SDL_GetTrayEntryParent;
extern fn SDL_GetTrayEntryParent(entry: *TrayEntry) ?*TrayMenu;

/// Gets the entry for which the menu is a submenu, if the current menu is a
/// submenu.
///
/// Either this function or `getTrayMenuParentTray` will return non-null
/// for any given menu.
pub const getTrayMenuParentEntry = SDL_GetTrayMenuParentEntry;
extern fn SDL_GetTrayMenuParentEntry(menu: *TrayMenu) ?*TrayEntry;

/// Gets the tray for which this menu is the first-level menu, if the current
/// menu isn't a submenu.
///
/// Either this function or `getTrayMenuParentEntry` will return non-null
/// for any given menu.
pub const getTrayMenuParentTray = SDL_GetTrayMenuParentTray;
extern fn SDL_GetTrayMenuParentTray(menu: *TrayMenu) ?*Tray;

/// Update the trays.
///
/// This is called automatically by the event loop and is only needed if you're
/// using trays but aren't handling SDL events.
pub const updateTrays = SDL_UpdateTrays;
extern fn SDL_UpdateTrays() void;
