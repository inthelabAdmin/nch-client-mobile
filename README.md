# National Calendar Hub Mobile (national_calendar_hub_app)

Mobile client for National Calendar Hub

## Getting Started

// TODO fill out onboading steps

## Smoke Testing

Follow these smoke testing steps to prep release

### Launch

1. Launch app, observe splash screen shows app icon
2. The spash screen should not take more than 5 seconds to load

### Home

- The home page should load within with a circular progress bar for a few seconds
  - "Today" should be displayed at the top on the page
  - Scroll down and you should see a sections "This month"
- The Home icon should be highlighted on the bottom navigtion
- Clicking an item should launch the "Details" screen

### Explore

- Click "Explore" on bottom navigation bar, you should now be on "Explore" tab
- The page should have an empty search bar and calender icon
- Type a keyword in search
  - After 2 characters, a request should be made and results should populate the list
  - An "X" should appear at the end on the search bar
  - Clicking a result should take you to "Details" screen
  - Clicking the "X" should clear the keywords and results
- Click the calendar icon
