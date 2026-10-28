import Foundation

enum SampleLibrary {
    static let albums: [Album] = [
        Album(id: "blue", title: "蓝色时刻", englishTitle: "BLUE HOUR", artist: "林间", year: 2026,
              genre: "独立流行", artwork: 0, description: "在日落与夜晚之间，把喧嚣留在身后。四首写给慢下来的生活的歌。"),
        Album(id: "coast", title: "海岸线", englishTitle: "COASTLINE", artist: "白噪声乐队", year: 2026,
              genre: "独立摇滚", artwork: 1, description: "一封从海边寄来的声音明信片。沿着公路，一直走到风里。"),
        Album(id: "hills", title: "山间来信", englishTitle: "LETTERS", artist: "陈以南", year: 2025,
              genre: "民谣", artwork: 2, description: "树影、清晨与远方的雨。让声音带你回到自然的呼吸。"),
        Album(id: "night", title: "午夜电台", englishTitle: "MIDNIGHT FM", artist: "渡", year: 2026,
              genre: "电子", artwork: 3, description: "城市渐渐睡去，频率依旧温热。给每个还醒着的灵魂。"),
        Album(id: "sun", title: "日光漫游", englishTitle: "SUNLIT", artist: "April Room", year: 2025,
              genre: "爵士", artwork: 4, description: "让阳光落在琴键上。属于午后、咖啡与无所事事的旋律。"),
        Album(id: "city", title: "城市留白", englishTitle: "QUIET CITY", artist: "回声计划", year: 2026,
              genre: "氛围音乐", artwork: 5, description: "在熟悉的街道找到新的空隙。留一点安静，听见自己。"),
        Album(id: "bloom", title: "缓慢发生", englishTitle: "SLOW BLOOM", artist: "林间", year: 2024,
              genre: "独立流行", artwork: 6, description: "有些美好的事，需要时间。从一颗种子开始的音乐旅行。"),
        Album(id: "wind", title: "远方的风", englishTitle: "FARAWAY", artist: "陈以南", year: 2024,
              genre: "民谣", artwork: 7, description: "在远方，也在此刻。记下路过的风景和没说完的话。")
    ]

    static let songs: [Song] = {
        let titles = [
            ["晚风经过窗边", "五点四十分", "把夜晚打开", "明天见"],
            ["沿海公路", "潮汐之间", "一公里的蓝"],
            ["山间来信", "候鸟", "雨落下之前"],
            ["午夜漫步", "电波里的你", "霓虹背面"],
            ["Sunday Morning", "A Cup of Sun", "慢一点也很好"],
            ["雨后的街道", "无人站台", "留白"],
            ["缓慢发生", "春日来信", "小小的光"],
            ["远方的风", "山谷回声", "一路向南"]
        ]
        return albums.enumerated().flatMap { index, album in
            titles[index].enumerated().map { track, title in
                Song(id: "\(album.id)-\(track + 1)", title: title, artist: album.artist,
                     albumID: album.id, track: track + 1, seconds: 204 + (index * 19 + track * 27) % 98)
            }
        }
    }()

    static let playlists = [
        MusicPlaylist(id: "evening", title: "晚风与耳机", subtitle: "把一天的忙碌，调成静音。", artwork: 0,
                      songIDs: ["blue-1", "coast-2", "hills-1", "night-2", "bloom-1", "wind-1", "blue-2", "city-1"]),
        MusicPlaylist(id: "focus", title: "专注时刻", subtitle: "让思绪安静，让灵感发生。", artwork: 2,
                      songIDs: ["city-3", "sun-2", "hills-2", "bloom-3", "city-2", "wind-2", "sun-1"])
    ]
}
