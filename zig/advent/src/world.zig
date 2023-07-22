const std = @import("std");
const gen = @import("generate.zig");
const print = std.debug.print;
const Str = []const u8;

pub var items = gen.items;
pub const Item = gen.Item;
pub var player = gen.player;
pub const ambiguous = gen.ambiguous;
pub const Distance = gen.Distance;

pub fn getDistanceNumber(from: ?*Item, to: ?*Item) usize {
    return @intFromEnum(getDistance(from, to));
}

pub fn getDistance(from: ?*Item, to: ?*Item) Distance {
    if (to == null or from == null) {
        return .distUnknownObject;
    }
    if (from == to) {
        return .distSelf;
    }
    if (isHolding(from, to)) {
        return .distHeld;
    }
    if (isHolding(to, from)) {
        return .distLocation;
    }
    if (isHolding(from.?.location, to)) {
        return .distHere;
    }
    if (getPassage(from.?.location, to) != null) {
        return .distOverthere;
    }
    if (isHolding(from, to.?.location)) {
        return .distHeldContained;
    }
    if (isHolding(from.?.location, to.?.location)) {
        return .distHereContained;
    }
    return .distNotHere;
}

fn isHolding(container: ?*Item, item: ?*Item) bool {
    if (container == null or item == null) return false;
    return item.?.location == container;
}

pub fn actorHere() ?*Item {
    const location = player.location;
    for (&items) |*item| {
        if (isHolding(location, item) and item.type == .guard) {
            return item;
        }
    }
    return null;
}

pub fn getItem(noun: ?Str, from: ?*Item, maxDistance: Distance) ?*Item {
    const word = noun orelse return null;
    const max = @intFromEnum(maxDistance);

    var item: ?*Item = null;
    for (&items) |*value| {
        if (value.hasTag(word) and getDistanceNumber(from, value) <= max) {
            if (item != null) return &ambiguous;
            item = value;
        }
    } else return item;
}

pub fn getPassage(from: ?*Item, to: ?*Item) ?*Item {
    if (from == null and to == null) return null;

    for (&items) |*item| {
        if (isHolding(from, item) and item.destination == to) {
            return item;
        }
    }
    return null;
}

pub fn getVisible(intention: Str, noun: ?Str) ?*Item {
    const item = getItem(noun, player, Distance.distOverthere);
    // print("get item: {s}", .{item.?})
    if (item == null) {
        if (getItem(noun, player, Distance.distNotHere) == null) {
            print("I don't understand {s}.\n", .{intention});
        } else {
            print("You don't see any {s} here.\n", .{noun.?});
        }
    } else if (item.?.isAmbiguous()) {
        print("Please be specific about which {s} you mean.\n", .{noun.?});
        return null;
    }
    return item;
}

pub fn listAtLocation(location: *Item) usize {
    var count: usize = 0;
    for (&items) |*item| {
        if (!item.isPlayer() and item.isLocate(location)) {
            if (count == 0) {
                print("You see:\n", .{});
            }
            print("{s}\n", .{item.desc});
            count += 1;
        }
    }
    return count;
}
