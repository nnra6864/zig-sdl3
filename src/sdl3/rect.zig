//! Rectangle Functions (SDL_rect.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The structure that defines a point (using integers).
pub const Point = extern struct {
    x: c_int,
    y: c_int,
};

/// The structure that defines a point (using floating point values).
pub const FPoint = extern struct {
    x: f32,
    y: f32,
};

/// A rectangle, with the origin at the upper left (using integers).
pub const Rect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,

    pub const toFRect = rectToFRect;
    pub const containsPoint = pointInRect;
    pub const isEmpty = rectEmpty;
    pub const equals = rectsEqual;
    pub const hasIntersection = hasRectIntersection;
    pub const getIntersection = getRectIntersection;
    pub const getUnion = getRectUnion;
    pub const getLineIntersection = getRectAndLineIntersection;
};

/// A rectangle stored using floating point values.
///
/// The origin of the coordinate space is in the top-left, with increasing
/// values moving down and right. The properties `x` and `y` represent the
/// coordinates of the top-left corner of the rectangle.
pub const FRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,

    pub const containsPoint = pointInRectFloat;
    pub const isEmpty = rectEmptyFloat;
    pub const equalsEpsilon = rectsEqualEpsilon;
    pub const equals = rectsEqualFloat;
    pub const hasIntersection = hasRectIntersectionFloat;
    pub const getIntersection = getRectIntersectionFloat;
    pub const getUnion = getRectUnionFloat;
    pub const getLineIntersection = getRectAndLineIntersectionFloat;
};

/// Convert a `Rect` to `FRect`
pub fn rectToFRect(rect: Rect) FRect {
    return .{
        .x = @floatFromInt(rect.x),
        .y = @floatFromInt(rect.y),
        .w = @floatFromInt(rect.w),
        .h = @floatFromInt(rect.h),
    };
}

/// Determine whether a point resides inside a rectangle.
///
/// A point is considered part of a rectangle if `p`'s x and y coordinates are >= to the rectangle's top left corner,
/// and < the rectangle's x+w and y+h. So a 1x1 rectangle considers point (0,0)
/// as "inside" and (0,1) as not.
pub fn pointInRect(p: Point, r: Rect) bool {
    return p.x >= r.x and p.x < r.x + r.w and p.y >= r.y and p.y < r.y + r.h;
}

/// Determine whether a rectangle has no area.
///
/// A rectangle is considered "empty" for this function if `r`'s width and/or height are <= 0.
pub fn rectEmpty(r: Rect) bool {
    return r.w <= 0 or r.h <= 0;
}

/// Determine whether two rectangles are equal.
///
/// Rectangles are considered equal if each of their x, y, width and height match.
pub fn rectsEqual(a: Rect, b: Rect) bool {
    return a.x == b.x and a.y == b.y and a.w == b.w and a.h == b.h;
}

/// Determine whether two rectangles intersect.
///
/// If either pointer is null the function will return false.
pub const hasRectIntersection = SDL_HasRectIntersection;
extern fn SDL_HasRectIntersection(A: *const Rect, B: *const Rect) bool;

/// Calculate the intersection of two rectangles.
///
/// Returns null if there is no intersection.
pub fn getRectIntersection(A: *const Rect, B: *const Rect) ?Rect {
    var result: Rect = undefined;
    if (!SDL_GetRectIntersection(A, B, &result)) return null;
    return result;
}
extern fn SDL_GetRectIntersection(A: *const Rect, B: *const Rect, result: *Rect) bool;

/// Calculate the union of two rectangles.
pub fn getRectUnion(A: *const Rect, B: *const Rect) Error!Rect {
    var result: Rect = undefined;
    if (!SDL_GetRectUnion(A, B, &result)) return makeError();
    return result;
}
extern fn SDL_GetRectUnion(A: *const Rect, B: *const Rect, result: *Rect) bool;

/// Calculate a minimal rectangle enclosing a set of points.
///
/// If `clip` is not null then only points inside of the clipping rectangle are
/// considered.
///
/// Returns null if all the points were outside of the clipping rectangle.
pub fn getRectEnclosingPoints(points: []const Point, clip: ?*const Rect) ?Rect {
    var result: Rect = undefined;
    if (!SDL_GetRectEnclosingPoints(points.ptr, @intCast(points.len), clip, &result)) return null;
    return result;
}
extern fn SDL_GetRectEnclosingPoints(points: [*]const Point, count: c_int, clip: ?*const Rect, result: *Rect) bool;

/// Calculate the intersection of a rectangle and line segment.
///
/// This function is used to clip a line segment to a rectangle. A line segment
/// contained entirely within the rectangle or that does not intersect will
/// remain unchanged. A line segment that crosses the rectangle at either or
/// both ends will be clipped to the boundary of the rectangle and the new
/// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
pub const getRectAndLineIntersection = SDL_GetRectAndLineIntersection;
extern fn SDL_GetRectAndLineIntersection(rect: *const Rect, X1: *c_int, Y1: *c_int, X2: *c_int, Y2: *c_int) bool;

/// Determine whether a point resides inside a floating point rectangle.
///
/// A point is considered part of a rectangle if `p`'s x and y coordinates are >= to the rectangle's top left corner,
/// and <= the rectangle's x+w and y+h. So a 1x1 rectangle considers point
/// (0,0) and (0,1) as "inside" and (0,2) as not.
pub fn pointInRectFloat(p: FPoint, r: FRect) bool {
    return p.x >= r.x and p.x <= r.x + r.w and p.y >= r.y and p.y <= r.y + r.h;
}

/// Determine whether a floating point rectangle takes no space.
///
/// A rectangle is considered "empty" for this function if `r`'s width and/or height are < 0.0f.
pub fn rectEmptyFloat(r: FRect) bool {
    return r.w < 0.0 or r.h < 0.0;
}

/// Determine whether two floating point rectangles are equal, within some
/// given epsilon.
///
/// Rectangles are considered equal if each of their x, y, width and height are within `epsilon` of each other. If you don't know
/// what value to use for `epsilon`, you should call the `rectsEqualFloat`
/// function instead.
pub fn rectsEqualEpsilon(a: FRect, b: FRect, epsilon: f32) bool {
    return @abs(a.x - b.x) <= epsilon and
        @abs(a.y - b.y) <= epsilon and
        @abs(a.w - b.w) <= epsilon and
        @abs(a.h - b.h) <= epsilon;
}

/// Determine whether two floating point rectangles are equal, within a default
/// epsilon.
///
/// Rectangles are considered equal if each of their x, y, width and height are within `std.math.floatEps(f32)` of each other. This is often
/// a reasonable way to compare two floating point rectangles and deal with the
/// slight precision variations in floating point calculations that tend to pop
/// up.
pub fn rectsEqualFloat(a: FRect, b: FRect) bool {
    return rectsEqualEpsilon(a, b, std.math.floatEps(f32));
}

/// Determine whether two rectangles intersect with float precision.
///
/// If either pointer is null the function will return false.
pub const hasRectIntersectionFloat = SDL_HasRectIntersectionFloat;
extern fn SDL_HasRectIntersectionFloat(A: *const FRect, B: *const FRect) bool;

/// Calculate the intersection of two rectangles with float precision.
///
/// Returns null if there is no intersection.
pub fn getRectIntersectionFloat(A: *const FRect, B: *const FRect) ?FRect {
    var result: FRect = undefined;
    if (!SDL_GetRectIntersectionFloat(A, B, &result)) return null;
    return result;
}
extern fn SDL_GetRectIntersectionFloat(A: *const FRect, B: *const FRect, result: *FRect) bool;

/// Calculate the union of two rectangles with float precision.
pub fn getRectUnionFloat(A: *const FRect, B: *const FRect) Error!FRect {
    var result: FRect = undefined;
    if (!SDL_GetRectUnionFloat(A, B, &result)) return makeError();
    return result;
}
extern fn SDL_GetRectUnionFloat(A: *const FRect, B: *const FRect, result: *FRect) bool;

/// Calculate a minimal rectangle enclosing a set of points with float
/// precision.
///
/// If `clip` is not null then only points inside of the clipping rectangle are
/// considered.
///
/// Returns null if all the points were outside of the clipping rectangle.
pub fn getRectEnclosingPointsFloat(points: []const FPoint, clip: ?*const FRect) ?FRect {
    var result: FRect = undefined;
    if (!SDL_GetRectEnclosingPointsFloat(points.ptr, @intCast(points.len), clip, &result)) return null;
    return result;
}
extern fn SDL_GetRectEnclosingPointsFloat(points: [*]const FPoint, count: c_int, clip: ?*const FRect, result: *FRect) bool;

/// Calculate the intersection of a rectangle and line segment with float
/// precision.
///
/// This function is used to clip a line segment to a rectangle. A line segment
/// contained entirely within the rectangle or that does not intersect will
/// remain unchanged. A line segment that crosses the rectangle at either or
/// both ends will be clipped to the boundary of the rectangle and the new
/// coordinates saved in `X1`, `Y1`, `X2`, and/or `Y2` as necessary.
pub const getRectAndLineIntersectionFloat = SDL_GetRectAndLineIntersectionFloat;
extern fn SDL_GetRectAndLineIntersectionFloat(rect: *const FRect, X1: *f32, Y1: *f32, X2: *f32, Y2: *f32) bool;
