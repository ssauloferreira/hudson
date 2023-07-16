<img src="docs\art\logo.png"  width=50% height=50%>

# hudson
Hudson is a project of a mobile application for financial management.

## Context
This project must be a mobile application of financial management. The main work goal is helping people to point their general incomes and expenses in order to organize their financial movements, making it possible by offering a quick view of recent transactions and organizing them by the days of the month. This app should be available initially for Android and (maybe) Web and for free.

First things first, the app functionalities are the following:
- Register recurring incomes and expenses
- Associate expense to a future income
- Add a spent to a debit or credit card
- Organize credit purchases by monthly billings
- Calendar view pointing the exchanges of each day of the month

## Technical Notes
The app is being developed using Flutter framework in order to make it easy to expand to another platform. For the first step, the database management system is based on SQLite and the data management is embbeded on the application code, with no back-end for a while. That decision was taken to make the application fully available offline with the simplest and quickest implementation, saving all the desired data local on the device. Although choosing a local database avoid multi-device syncing in this first version, that adoption bring more security to the user data, making it safer.

## Page Flow
The following image presents the application flow diagram, when we can consider the black node "Login" as the starter point of the user workflow.

![Flow diagram](docs/flow-diagram.png)

## Pages
The following section shows the main screenshots of the application, using some generic data to explore each page of the system.

### Login Page
![Login page](/docs/page-screenshots/LoginPage.png)

### Home Page
![Home page](/docs/page-screenshots/HomePage.png)
![Home page 2](/docs/page-screenshots/HomePage2.png)

### Account Pages
![Account list page](/docs/page-screenshots/AccountListPage.png)
![Account details page](/docs/page-screenshots/AccountDetailsPage.png)

### Card Pages
![Card list page](/docs/page-screenshots/CardListPage.png)
![Card details page](/docs/page-screenshots/CardDetailsPage.png)

### Exchange Pages
![Exchange list page](/docs/page-screenshots/ExchangeListPage.png)
![Exchange details page](/docs/page-screenshots/ExchangeDetailsPage.png)

### Report Page

<img src="docs/page-screenshots/ReportPage.png"  width=50% height=50%>

## Widget Tree
This section looks for present the widget trees from all the pages developed in this application. The home page show the most complex composition but the CRUD pages (i.e. list and details pages) are all similar to each others.

### Login Page
![Login page](/docs/widget-tree/Login.png)

### Home Page
![Home page](/docs/widget-tree/Home.png)

### Account List Page
![Account list page](/docs/widget-tree/AccountListPage.png)

### Account Details Page
![Account details page](/docs/widget-tree/AccountDetailsPage.png)

### Card List Page
![Card list page](/docs/widget-tree/CardListPage.png)

### Card Details Page
![Card details page](/docs/widget-tree/CardDetailsPage.png)

### Exchange List Page
![Exchange list page](/docs/widget-tree/ExchangeListPage.png)

### Exchange Details Page
![Exchange details page](/docs/widget-tree/ExchangeDetailsPage.png)

### Report Page
![Report page](/docs/widget-tree/ReportPage.png)


## Refferences
1. Flutter Framework https://flutter.dev/
1. FastAPI Framework https://fastapi.tiangolo.com/
1. Postgres https://www.postgresql.org/

