# InfinitePager

SwiftUI library for creating infinite pagination with dynamic SwiftUI views.

<!-- ![demo gif](img/demo.gif) -->

## Features

-   By using `UIPageViewController`, InfinitePager can perform page transitions similar to the native iOS.
-   updates its views using a `@propertyWrapper`. It's more efficient than re-creating views, which other similar libraries do.

## How it works

InfinitePager passes 3 SwiftUI views that retains `@Binding` to `UIPageViewController`, and updates the `@Binding` variables when swiping the page. It only updates 1 page per swipe. During page transitions, maximum visible pages are 2, one page is the previous page, and the other page is the next page. InfinitePager updates the off-screen page. As a result, the visible page is always sandwiched between the next and previous pages.

## How it differs from other libraries

-   [SwiftUIPager](https://github.com/fermoya/SwiftUIPager)
    -   has its own page transition animation
    -   stores all views intended for displaying
    -   can add views dynamically
    -   not capable for showing complex views
-   [Pages](https://github.com/nachonavarro/Pages)
    -   uses `UIPageViewController`
    -   can only display as many views as there are in the provided data

| Feature                 | InfinitePager           | SwiftUIPager | Pages |
| ----------------------- | ----------------------- | ------------ | ----- |
| native page transitions | ✓                       | ×            | ✓     |
| infinite pagination     | ✓                       | △            | ×     |
| complex view            | ✓                       | △            | ✓     |
| customization           | × (maybe in the future) | ✓            | △     |

## Installation

not yet

## Usage

Create a view that has a `@Binding` variable for the page number.

```swift
struct ContentView: View {
    var body: some View {
        InfinitePager(initialPageNum: 0) { pageNum in
            SamplePage(pageNumber: pageNum)
        }
    }
}
```

## Requirements

only tested on iOS 14.3, but it should work on iOS 13.0+

## Contributing

## Contact Information

## License

MIT

