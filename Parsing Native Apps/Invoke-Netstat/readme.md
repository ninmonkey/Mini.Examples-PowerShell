
[Invoke-Netstat.ps1](./Invoke-Netstat.ps1)

- uses `(?x)` verbose mode for cleaner patterns
- The **Group Names** are used to automatically create a `[pscustomobject]`
- **Property names** come from **Group names** in the regex

![Screenshot of Commandline Objects](./final-posh-objects.png)

Testing the regex on [Regex101](https://regex101.com/)

![Screenshot of Regex Hilighted groups](./regex101.highlighted-matches.png)