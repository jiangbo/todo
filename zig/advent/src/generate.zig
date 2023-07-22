const std = @import("std");
const json = std.json;
const Str = []const u8;
const payload =
    \\    {
    \\        "desc": "an open field",
    \\        "type": "field",
    \\        "tags": ["field"]
    \\    }
;

pub var items = blk: {
    var buf: [32]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    const res = json.parseFromSliceLeaky(Item, fba.allocator(), payload, .{});
    break :blk res catch unreachable;
};

pub const player: *Item = &items[5];
pub const ambiguous: Item = .{
    .desc = "ambiguous",
    .type = .ambiguous,
    .tags = &[_]Str{
        "ambiguous",
    },
};

pub const Distance = enum {
    distSelf,
    distHeld,
    distHeldContained,
    distLocation,
    distHere,
    distHereContained,
    distOverthere,
    distNotHere,
    distUnknownObject,
};

pub const Item = struct {
    desc: Str,
    type: enum {
        ambiguous,
        field,
        cave,
        silver,
        gold,
        guard,
        player,
        entrance,
        exit,
        forest,
        rock,
    },
    tags: []const Str,
    location: ?*Item = null,
    destination: ?*Item = null,

    pub fn isPlayer(self: *Item) bool {
        return self.type == .player;
    }

    pub fn isLocation(self: *Item) bool {
        return self.location == null;
    }

    fn isLocate(self: *Item, location: *Item) bool {
        return self.location == location;
    }

    pub fn isPlayerIn(self: *Item) bool {
        return self == player.location;
    }

    pub fn isPlayerItem(self: *Item) bool {
        return self.location == player;
    }

    pub fn isNpcItem(self: *Item) bool {
        const location = self.location orelse return false;
        return location.type == .guard;
    }

    pub fn isWithPlayer(self: *Item) bool {
        return self.isLocate(player.location.?);
    }

    // pub fn distanceWithPlayer(self: *Item) Distance {
    //     return getDistance(player, self);
    // }

    pub fn isAmbiguous(self: *Item) bool {
        return self.type == .ambiguous;
    }

    pub fn hasTag(self: *Item, noun: Str) bool {
        for (self.tags) |tag| {
            if (std.mem.eql(u8, noun, tag)) {
                return true;
            }
        } else return false;
    }
};
