function Test-ConsoleSpecialFont {
    <#
    .synopsis
        Prints a test page for  special characters, ie: to check if PowerLine and custom ligatures are working
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Abbr, print a shorter test
        [Parameter()][switch]$ShortExample
    )
    $TemplateShort = @'

    # Context-aware alignment

    fii fjj
    a*b a*A B*b A*B *a *A a* A*
    a-b a-A B-b A-B -a -A a- A-
    a+b a+A B+b A+B +a +A a+ A+
    a:b a:A B:b A:B :a :A a: A:

    # Powerline

          

    # Stylistic sets

    r 0 123456789 & && $ <$ <$> $> @ <= >=

    \n  \\  /* */  /// //
    </ <!--  </>  --> />
    0xF www Fl Tl Il fi fj

    ;; :: ::: !! ?? %% &&
    || .. ... ..< .? ?.
    -- --- ++ +++ ** ***

    =~ !~ ~- -~ ~@
    ^= ?= /= /==
    -| _|_ |- ||- |= ||=
    #! #= ## ### ####
    #{ #[ ]# #( #? #_ #_(
'@
    $TemplateAll = @'

      .= .- ..= := ::= =:= __
     == != === !== =/= =!=

<-< <<- <-- <- <-> -> --> ->> >->
<=< <<= <== <<->> <=> => ==> =>> >=>
    >>= >>- >- <~> -< -<< =<<
      <-| <=| /\ \/ |-> |=>
        <~~ <~ ~~ ~> ~~>

     <<< << <= <> >= >> >>>
       {. {| [|  |] |} .}
<:> >:< >:> <:< :>: :<: :> :< >: <:
   <||| <|| <| <|> |> ||> |||>

            <$ <$> $>
            <+ <+> +>
            <* <*> *>

      \n  \\  /* */  /// //
      </ <!--  </>  --> />
      0xF www Fl Tl Il fi fj

       ;; :: ::: !! ?? %% &&
        || .. ... ..< .? ?.
       -- --- ++ +++ ** ***

         =~ !~ ~- -~ ~@
          ^= ?= /= /==
       -| _|_ |- ||- |= ||=
        #! #= ## ### ####
      #{ #[ ]# #( #? #_ #_(

# Context-aware alignment

fii fjj
a*b a*A B*b A*B *a *A a* A*
a-b a-A B-b A-B -a -A a- A-
a+b a+A B+b A+B +a +A a+ A+
a:b a:A B:b A:B :a :A a: A:

# Powerline

      

# Stylistic sets

r 0 123456789 & && $ <$ <$> $> @ <= >=

# Unicode

≢ ẞ ᐅ ᐊ ∴ ∵ ⎈ ‖ ∧ ∨ ⊢ ⊣ ⊤ ⊥ ⊦ ⊧ ⊨ ⊩ ⊪ ⊫ ⊬ ⊭ ⊮ ⊯
⟲⟳ ⟰ ⟱ ⟴ ⟵ ⟶ ⟷ ⟸ ⟹ ⟺ ⟻ ⟼ ⟽ ⟾ ⟿
↩ ⇞ ⇟ ⇤ ⇥ ⌀ ⌃ ⌄ ⌅ ⌆ ⌘ ⌤ ⌥ ⎇ ⎋ ⏏ ✓ ☐ ☑ ☒ ▤ ▦ ▧ ▨ ▩
␆ ␈ ␇ ␣ ␢ ␘ ␍ ␐ ␡ ␥ ␔ ␑ ␓ ␒ ␙ ␃ ␄ ␗ ␅ ␛ ␜ ␌ ␝ ␉ ␊ ␕ ␤ ␀ ␞ ␏ ␎ ␠ ␁ ␂ ␚ ␦ ␖ ␟ ␋
ℂ ℍ ℕ ℙ ℚ ℝ ℤ 𝔹 ∀ ∃ ∄ ∅ ⊂ ⊃ ⊄ ⊅ ⊆ ⊇ ⊈ ⊉ ⊊ ⊋ ∈ ∉ ∊ ∋ ∌ ∍ ∪ ∩
☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷ 「a」 ｢a｣

# Box drawing

╭╌╌╌╌╮ ╭┄┄┄┄╮ ╭┈┈┈┈╮
╎    ╏ ┆    ┇ ┊    ┋
╎    ╏ ┆    ┇ ┊    ┋
╰╍╍╍╍╯ ╰┅┅┅┅╯ ╰┉┉┉┉╯

┌─┬─┐ ╔╦═╗ ┏━┳┓ ╒═╤═╗ ╭─┰─╮ ○   ○ ◆ ◆
├─┼─┤ ╠╬═╣ ┣━╋┫ ├─┼─╢ ┝━╋━┥  ╲ ╱   ╳
└─┴─┘ ╚╩═╝ ┗━┻┛ ╘═╧═╝ ╰─┸─╯   ■   ◆ ◆

# Blocks

|███   | 50%

▖ ▗ ▙ ▚ ▛ ▜ ▞ ▟
'@

    if ($ShortExample) {
        $TemplateShort
        return
    }

    $Url = 'https://raw.githubusercontent.com/tonsky/FiraCode/master/extras/showcases.txt'
    $resp = Invoke-WebRequest -Uri $url
    $resp.RawContent
    Write-Verbose "Downloading latest: '$url'"
}
