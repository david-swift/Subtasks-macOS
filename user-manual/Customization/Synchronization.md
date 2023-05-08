# Synchronize With [Supabase][1]

You can synchronize the tasks with a [Supabase][2] database, for example for using Subtasks on multiple devices.

![Successful Synchronization][image-1]

1. Sign up or log in on [Supabase][3].
2. Click on `New project`.
3. Name your project, and set the password and region.
4. Click on `Create new project`.
5. Click on `Copy` under `Project API keys` \> `anon` `public`
6. Paste the copied key with `⌘V` into the `Supase Key` text field under `Subtasks` \> `Settings` \> `Synchronization`.
7. Hover over the symbols on the left in Supabase. Click on the terminal symbol with the name `SQL Editor`.
8. Click on the `New query` button above the search field.
9. Click on the down arrow `˯` next to the query’s name, click on `Rename` and rename it to “Create table”.
10. Paste the following code into the editor:
```sql
create table public.tasks (
	id integer not null primary key default 0,
	data text not null
);
```
11. Click on `Run` in the bottom right corner or press `⌘↩︎`.
12. Click on the table icon on the left above the SQL editor symbol.
13. Select the table “tasks” on the left and click on the button `API` on the top right.
14. Click on `Copy` under `API URL` \> `API URL` and paste it into the `Supabase URL` text field under `Subtasks` \> `Settings` \> `Synchronization`.
15. Now, edit a task. Check if a row is added to the table.

[1]:	https://supabase.com
[2]:	https://supabase.com
[3]:	https://app.supabase.com/sign-up

[image-1]:	../../Icons/Synchronization.png