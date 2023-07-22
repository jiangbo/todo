const std = @import("std");
const location = @import("location.zig");
const inventory = @import("inventory.zig");
const print = std.debug.print;

pub fn main() !void {
    print("Welcome to Little Cave Adventure.\n", .{});
    const reader = std.io.getStdIn().reader();
    _ = location.lookAround();
    var buffer: [100]u8 = undefined;

    while (true) {
        print("--> ", .{});
        var input = try getInput(reader, buffer[0..]) orelse continue;
        if (std.mem.eql(u8, input, "quit")) {
            break;
        }
        parseAndExecute(input);
    }

    print("\nBye!\n", .{});
}

fn getInput(reader: anytype, buffer: []u8) !?[]const u8 {
    if (try reader.readUntilDelimiterOrEof(buffer, '\n')) |input| {
        if (@import("builtin").os.tag == .windows) {
            return std.mem.trimRight(u8, input, "\r");
        }
        return input;
    }
    return null;
}

const Action = enum {
    look,
    go,
    get,
    drop,
    give,
    ask,
    inventory,
    unknown,
};

pub fn parseAndExecute(input: []const u8) void {
    var iterator = std.mem.split(u8, input, " ");
    const verb = iterator.next() orelse return;
    const noun = iterator.rest();

    const action = std.meta.stringToEnum(Action, verb) orelse .unknown;
    switch (action) {
        .look => {
            if (!location.executeLook(noun))
                print("I don't understand what you want to see.\n", .{});
        },
        .go => {
            if (!location.executeGo(noun))
                print("I don't understand where you want to go.\n", .{});
        },
        .get => inventory.executeGet(noun),
        .drop => inventory.executeDrop(noun),
        .give => inventory.executeGive(noun),
        .ask => inventory.executeAsk(noun),
        .inventory => inventory.executeInventory(),
        .unknown => print("I don't know how to {s}.\n", .{verb}),
    }
}
