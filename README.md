# Gdot - Gerry's Dot Files

I didn't intend on other people using this, so I didn't write much of a readme.

`(macOS|Linux)`:

```sh
curl -o bootstrap.sh https://raw.githubusercontent.com/gplusplus314/gdot/main/.config/gdot/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
```

`FreeBSD`:

```sh
fetch https://raw.githubusercontent.com/gplusplus314/gdot/main/.config/gdot/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
```

If you're wondering how this works, follow along in
[bootstrap.sh](.config/gdot/bootstrap.sh). An explanation of how the actual
bare git repo works can be found
[here](<https://www.atlassian.com/git/tutorials/dotfiles>].

Using my dotfiles, I have the command `gdot` which basically just wraps `git`
with all of the bare-repository arguments baked in. I also use `.gitignore`
everywhere to decide what makes it into the repository.
