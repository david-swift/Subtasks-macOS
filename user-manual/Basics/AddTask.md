# Add a Task

You can add a task to the list or subtask to a task.

![Task Entry Popover][image-1]

## 1. Open the Task Entry Popover

Adding a task requires two steps: Opening a text field for entering information about a task and entering the information. There are multiple ways to accomplish the first step.

### Open the Task Entry Popover Using the Toolbar Button

By default, there is the `+` button in the toolbar. Click on it to open the task entry popover.

### Open the Task Entry Popover Using the Command

You can open the task entry popover via `File` \> `New Task` or press `⌘N`.

## 2. Enter Information About the Task

Enter the information and press enter (↩︎). While entering, the preview in the popover is being updated.

The syntax looks like that:

	Title @d: Description @c: true @p: high

You can omit any part or change the order. Only the title has to be at the beginning.

### Title

Simply enter text into the field, for example:

	Buy Groceries

If not specified, the title is empty.

### Description

Write `@d:` followed by the description, for example:

	@d: Do not forget the **tomatoes**!

If not specified, the description is empty.

#### Markdown

The title and description offer basic Markdown styling options. Here is an overview:

| Syntax                                 | Effect                             |
| -------------------------------------- | ---------------------------------- |
| Text                                   | A normal text without any styling. |
| \*\*Text\*\*                   		 | A **bold** text.                   |
| \_\_Text\_\_                   		 | A __bold__ text.                   |
| \*Text\*                           	 | An *italic* text.                  |
| \_Text\_                           	 | An _italic_ text.                  |
| \[Hi\]\(https://www.example.com/\) 	 | A [link][1].                       |
| \`Text\`                           	 | A `code`.                          |
| \~Text\~                           	 | A ~~strikethrough~~ text.      	  |

### Completion

Write `@c:` followed by `true` for completing the task or anything else for not completing it, for example:

	@c: true

### Priority

Write `@p:` followed by `high` for settings the priority to high or anything else for settings the priority to regular, for example:

	@p: high

[1]:	https://example.com/

[image-1]:	../../Icons/AddTask.png