give me flutter code for an expense tracker

it has:
    firebase for authentication & database
    beautiful, clean and minimal user interface with good transitions (based on details under "# user interface")
    custom expense entity (based on details under "# expense entity")
    
below is detailed info about the app

# user interface
{

    User Interface:
        side bar:
            at top display user data:
                profile picture
                name
            home:
                has a overview of previous expenses or can be empty
                displays previous 3 expenses (customizable)
                has a floating action button
                floating action button:
                    to add an expense
                    opens a form
                    form:
                        currency - inr, usd, etc 
                        amount
                        note (dropdown)
                        date (default will be current date)
                        category (dropdown)
                        label (dropdown)
                        submit button
            statistics:
                detailed ananysis of user data
                can show various graphs witin a specific datetime range (customizable based on category, lable, datetime, expanseAmount, )
            profile:
                standard user profile
}

# expense entity
{

    # to be stored in database (can have other expenses nested within under "expense key")

    expenseEntity {
        id: "expjsndkvj df8vudf9vudf9 udfv0d9f" # auto generated, 64 characters lone
        timestamp: "" # generated at the time of adding expense
        date: "" # custom date selected by user or current date
        expenseCategory: "" # selected by user when adding expense (from a drop down menu, user can also create/delete custom categories)
        expenseLabel: ""  # selected by user when adding expense (from a drop down menu, user can also create/delete custom labels)
        expenseNote: ""  # added by user when adding expense (from a Text input)
        expenseAmount: "" # total expense amount including total from nested expense entities 
        expense: "" # could be empty, same expense amount or contain nested expense entity
    }

}
