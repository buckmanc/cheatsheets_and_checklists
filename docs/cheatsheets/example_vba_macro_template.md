# Example VBA Macro
Full Version

## Background

[Visual Basic for Applications](https://en.wikipedia.org/wiki/Visual_Basic_for_Applications) (VBA) is the language Excel macros are written in. VBA is based on [VB6](https://en.wikipedia.org/wiki/Visual_Basic_%28classic%29), which was last updated in 1998. Still, for many folks in locked-down corporate environments, it remains the most accessible method of scripting tasks.

If you're looking to write a VBA macro, keep in mind that VBA is *very old* at this point, and that *good* examples may be hard to come by.

I started coding by tinkering with existing macros I used on the job. Not many years after that I was a full-time developer moving on to C# and SQL. Not everybody has the opportunities necessary for that, but it's a very valid path.

## How To Use This Example

### Quick Version

1. Download the [example macro](/misc/ExampleMacro.xlsm)
1. Follow the [simple instructions](example_vba_macro_simple.md)

### Manual Version

1. Open Excel
1. Start a new blank workbook
1. Add the Developer tab if you don't already have it
    1. Right click on the ribbon up top
    1. Select "Customize the Ribbon"
    1. In the right column, scroll down and check "Developer"
    1. Hit "OK"
1. Click the "Developer" > Visual Basic
1. Put the damned VBA window somewhere more useful than where it just popped up
    - In the future the VBA window can be opened by pressing Alt+F11
1. Click "This Workbook" under the tree for your file
1. Copy the below macro and paste it there
1. Copy the below table and paste it into your spreadsheet
1. Run the macro by either
    - Clicking the "play" button in the VBA window
    - Hitting "F5" in the VBA window
    - Adding a button to your spreadsheet and assigning this macro to it
        - "Developer" > Insert > Button > draw the button > select your macro > click "OK"
1. View the results
1. Think about how easy it would be to tweak this example to fit your business logic

## Example Macro

```vb
{macro_code}
```

## Corresponding Spreadsheet Table

{spreadsheet_table}

## Further Tips

- Remember [Adam Savage's 2nd and 4th commandments for makers](./ten_commandments_for_makers.md): "Make stuff that improves your life" and "Learn with a project."
    - Don't overwhelm yourself by learning stuff that won't be useful right away
    - Don't learn additional stuff because you feel obligated to; as you improve your life satisfaction and curiosity will drive you to learn more
- You can get limited help by placing your cursor on a keyword (like ".Range" or "vbNullString") and hitting F1

## Useful VBA Settings

- Show the Immediate and Locals windows
    - VBA Window > View > Immediate Window, Locals Window
- Add the Debug toolbar
    - VBA Window > Toolbars > Debug
