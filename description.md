#### Demo Description

This is a simple Shiny app to demonstrate some Shiny and R capabilities. The app utilizes the `quantmod` package to retrieve data from Yahoo! Finance.

- First, user can select one of three exchanges (AMEX, NASDAQ, NYSE)
- The app then retrieves the list of currently available symbols of the selected exchange, and generates a dynamic user control from these symbols
- User can select one of the available symbols
- The retrieves data for the selected symbol, and outputs a simple time series visualization.
