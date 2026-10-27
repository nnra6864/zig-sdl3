//! Locale Info (SDL_locale.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// A struct to provide locale data.
///
/// Locale data is split into a spoken language, like English, and an optional
/// country, like Canada. The language will be in ISO-639 format (so English
/// would be "en"), and the country, if not null, will be an ISO-3166 country
/// code (so Canada would be "CA").
pub const Locale = extern struct {
    /// A language name, like "en" for English.
    language: ?[*:0]const u8,
    /// A country, like "US" for America. Can be null.
    country: ?[*:0]const u8,
};

/// Report the user's preferred locale.
///
/// Returned language strings are in the format xx, where 'xx' is an ISO-639
/// language specifier (such as "en" for English, "de" for German, etc).
/// Country strings are in the format YY, where "YY" is an ISO-3166 country
/// code (such as "US" for the United States, "CA" for Canada, etc). Country
/// might be null if there's no specific guidance on them (so you might get {
/// "en", "US" } for American English, but { "en", null } means "English
/// language, generically"). Language strings are never null, except to
/// terminate the array.
///
/// Please note that not all of these strings are 2 characters; some are three
/// or more.
///
/// The returned list of locales are in the order of the user's preference. For
/// example, a German citizen that is fluent in US English and knows enough
/// Japanese to navigate around Tokyo might have a list like: { "de", "en_US",
/// "jp", null }. Someone from England might prefer British English (where
/// "color" is spelled "colour", etc), but will settle for anything like it: {
/// "en_GB", "en", null }.
///
/// This function returns null on error, including when the platform does not
/// supply this information at all.
///
/// This might be a "slow" call that has to query the operating system. It's
/// best to ask for this once and save the results. However, this list can
/// change, usually because the user has changed a system preference outside of
/// your program; SDL will send an `EventType.locale_changed` event in this case,
/// if possible, and you can call this function again to get an updated copy of
/// preferred locales.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getPreferredLocales() Error![]*Locale {
    var count: c_int = undefined;
    const ptr = SDL_GetPreferredLocales(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetPreferredLocales(count: ?*c_int) ?[*]*Locale;
