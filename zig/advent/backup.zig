// var list = [_]Item{
//         .{
//             .desc = "an open field",
//             .type = .field,
//             .tags = &[_]Str{"field"},
//         },
//         .{
//             .desc = "a little cave",
//             .type = .cave,
//             .tags = &[_]Str{"cave"},
//         },
//         .{
//             .desc = "a silver coin",
//             .type = .silver,
//             .tags = &[_]Str{ "silver", "coin", "silver coin" },
//         },
//         .{
//             .desc = "a gold coin",
//             .type = .gold,
//             .tags = &[_]Str{ "gold", "coin", "gold coin" },
//         },
//         .{
//             .desc = "a burly guard",
//             .type = .guard,
//             .tags = &[_]Str{ "guard", "burly guard" },
//         },
//         .{ .desc = "yourself", .type = .player, .tags = &[_]Str{"yourself"} },
//         .{
//             .desc = "a cave entrance to the east",
//             .type = .entrance,
//             .tags = &[_]Str{ "east", "entrance" },
//         },
//         .{ .desc = "an exit to the west", .type = .exit, .tags = &[_]Str{ "west", "exit" } },
//         .{
//             .desc = "dense forest all around",
//             .type = .forest,
//             .tags = &[_]Str{ "west", "north", "south", "forest" },
//         },
//         .{
//             .desc = "solid rock all around",
//             .type = .rock,
//             .tags = &[_]Str{ "east", "north", "south", "rock" },
//         },
//     };

//     list[2].location = &list[0];
//     list[3].location = &list[1];
//     list[4].location = &list[0];
//     list[5].location = &list[0];

//     list[6].location = &list[0];
//     list[6].destination = &list[1];

//     list[7].location = &list[1];
//     list[7].destination = &list[0];

//     list[8].location = &list[0];
//     list[9].location = &list[1];
