# NordicGYM

## Home screen data

`NordicGym/DTOs/DTOs.swift` defines the `HomeContent` Decodable payload, reusing
the member, class, booking, and featured-content models. A matching fixture is
bundled at `NordicGym/Resources/home-sample.json`.

```swift
let url = Bundle.main.url(forResource: "home-sample", withExtension: "json")!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
let home = try decoder.decode(HomeContent.self, from: Data(contentsOf: url))
```

The fixture uses Thursday, September 10, 2026 at 09:41 in `Europe/Oslo` as its
reference time. Relative to that time, classes run from “Tomorrow” through Monday,
and friend activity ranges from “3 hours ago” to two days ago. For a live screen, use
the current time. Group upcoming classes by day using the `Europe/Oslo` time zone.
Format times, durations, and availability in the view layer. Activity messages
include Markdown emphasis for the member and class names.

The root `items` array holds modules in screenshot order. Each module has a
`type` discriminator and `content`: an array for `upcomingClasses`, `friendActivity`,
and `joinYourFriends`, or a single object for `featuredContent`.

The fixture contains four upcoming classes, five friend activities, and four
classes to join. It covers all four booking states, full classes with zero spots,
one remaining spot, and more availability, plus liked and unliked activities.
Members are fictional and reused consistently across modules. Dates, locations,
instructors, and availability are illustrative, not a live gym schedule.

Every image property contains a direct HTTPS image URL. Profile photos use
[Random User test portraits](https://randomuser.me/). Class and featured images
use Pexels photos of [dance](https://www.pexels.com/photo/group-of-people-in-a-fitness-class-5936039/),
[rowing](https://www.pexels.com/photo/person-exercising-at-a-gym-4162486/),
[cycling](https://www.pexels.com/photo/man-training-on-an-exercise-bike-4162595/),
[yoga](https://www.pexels.com/photo/women-doing-yoga-in-the-studio-4587342/),
[strength training](https://www.pexels.com/photo/photo-of-woman-using-dumbbells-3757943/),
and [a dumbbell workout](https://www.pexels.com/photo/a-woman-using-a-dumbbells-in-the-gym-4587371/).
All 11 distinct URLs returned HTTP 200 and `image/jpeg` when checked on
September 12, 2026. Remote images require network access.

Branding and button labels stay in the UI. The screen still uses its existing
view-data previews.

## TODO

- [ ] Make modules to create the home screen
