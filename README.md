<p align="center"><a href="#"><img src="https://user-images.githubusercontent.com/48920263/200191877-cf2b000b-e3a7-44bf-ad62-a72d6a855a81.png" draggable="false" ondragstart="return false;" alt="Dotfiles Title" title="Dotfiles" /></a></p>

This dotfiles project is a combination of some shell scripts and configuration
files. The shell scripts automate the installation of development tools, apps,
and symbolic links. These dotfiles are simply configurations files located in
a Cloud storage to synchronize multiple systems (workstations) with the same
configuration.
<br/><br/>

<p align="center"><a href="#"><img src="https://user-images.githubusercontent.com/48920263/200195577-89b63f31-2022-4e64-96b9-ab2ef423ce67.png" draggable="false" ondragstart="return false;" alt="Dotfiles Title" title="Terminal" /></a></p>

## Design Concept

### Using a Cloud Service Instead of GitHub

I started putting my dotfiles into iCloud Drive. I’m already part of the Apple
ecosystem and paying for an iCloud subscription so I thought it made sense
to move my dotfiles there. My latest configuration always stays in Github. To
sync, I simply push or pull the updates as I make them.

### What are the benefits of working in the Cloud?

The benefit of a cloud service, such as Dropbox, Google Drive or iCloud Drive
is the real-time syncing, so when you make edits to your configuration, your
other systems are being updated. You can keep the same folder structure and use
Github as a backup and reference to sharing this repo.<br/><br/>

<p align="center"><a href="#"><img src="https://user-images.githubusercontent.com/48920263/111876965-57295a80-89a1-11eb-9ef7-44f60df1648a.png" draggable="false" ondragstart="return false;" alt="iCloud Sync Status" title="iCloud Sync Status" width="590px" /></a></p>

## Getting started

> **Note:** these dotfiles are a collection of my configurations if you want to
give it a try, you should first review the code, and remove things you don’t
need. Do not blindly use these settings unless you know what that entails.

### Installation

The [Bootstrap][bootstrap] script will install and configure packages managed
by [Homebrew][brew], [npm][npm], [mas][mas] and [Mackup][mackup]. After that,
it will set the macOS settings. Finally, it will symlink the dotfiles to your
home directory and keep the original ones in place&#8198;&#8213;&#8198;in my
case in iCloud Drive as mentioned [before][up]&#8198;&#8213;&#8198;keeping all
your systems in sync.

Let's get started, download the repository via curl:

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nicolodiamante/dotfiles/HEAD/bootstrap.sh)"
```

The script will clone this repository to
`~/Library/Mobile Documents/com~apple~CloudDocs/dotfiles`. If iCloud Drive is
not available, it will clone it to `~/dotfiles`.

### Install Manually

As an alternative, you can download it first:

```shell
git clone https://github.com/nicolodiamante/dotfiles.git ~
```

Head over into the dotfiles directory and run the script:

```shell
cd bin && source bootstrap.sh
```

## Notes

### Mackup

Until the XDG Base Directory support (see [#632][#632]) for
`mackup.cfg` will not get fixed, the installation will proced by:

```shell
ln -s ~/.config/mackup/.mackup.cfg ~
```

### Add custom commands without creating a new fork

You can use `user/config` to add a few custom commands without the need to fork
this entire repository, or to add commands you don’t want to commit to a public repository. You can also have additional files at the `user/` directory
which will be sourced automatically from the `zshrc` and ignore by git.

> **Note:** the installation script will create the user folder with the configuration file inside it with the following settings:

```shell
# Git credentials
# Prevent people from accidentally committing under your name.
GIT_USER=$(git config user.name)
GIT_EMAIL=$(git config user.email)
GIT_EDITOR=$(git config core.editor)
GIT_BRANCH=$(git config init.defaultBranch)

if [[ -z "$GIT_USER" || -z "$GIT_EMAIL" || -z "$GIT_EDITOR" || -z "$GIT_BRANCH" ]]; then
  # Your Git credential.
  GIT_AUTH_NAME="Your name"
  GIT_AUTH_EMAIL="Your email"
  GIT_CORE_EDITOR="code --wait"
  GIT_DEFAULT_BRANCH="main"

  [[ -n "$GIT_AUTH_NAME" ]] && git config --global user.name "${GIT_AUTH_NAME}"
  [[ -n "$GIT_AUTH_EMAIL" ]] && git config --global user.email "${GIT_AUTH_EMAIL}"
  [[ -n "$GIT_CORE_EDITOR" ]] && git config --global core.editor "${GIT_CORE_EDITOR}"
  [[ -n "$GIT_DEFAULT_BRANCH" ]] && git config --global init.defaultBranch "${GIT_DEFAULT_BRANCH}"
fi
```
<br/>

### Resources

#### Arch Linux

- [Zsh (Wiki)][archw-zsh]

#### Base Directory

- [XDG Base Directory Specification][XDG]

#### Zsh Documentations

- [Documentation Index][zsh-docs]
- [User Guide][zsh-docs-guide]
- [Startup Files][zsh-docs-startup_files]
- [Variable Index][zsh-docs-var_idex]
- [Shell Grammar][zsh-docs-shell_grammar]

### Contribution

Please report any issues or bugs to the [issues page][issues]. Suggestions
for improvements are welcome!<br/><br/>

<p align="center"><a href="#"><img src="https://user-images.githubusercontent.com/48920263/113406768-5a164900-93ac-11eb-94a7-09377a52bf53.png" draggable="false" ondragstart="return false;" /></a></p>

<p align="center"><a href="https://github.com/nicolodiamante" target="_blank"><img src="https://user-images.githubusercontent.com/48920263/113433823-31a84200-93e0-11eb-9ffb-9111b389ef2f.png" draggable="false" ondragstart="return false;" alt="Nicol&#242; Diamante Portfolio" title="Nicol&#242; Diamante" width="11px" /></a></p>

<p align="center"><a href="https://github.com/nicolodiamante/dotfiles/blob/main/LICENSE.md" target="_blank"><img src="https://user-images.githubusercontent.com/48920263/110947109-06ca5100-8340-11eb-99cf-8d245044b8a3.png" draggable="false" ondragstart="return false;" alt="The MIT License" title="The MIT License (MIT)" width="90px" /></a></p>

<!-- Link labels: -->
[bootstrap]: bootstrap.sh
[brew]: https://brew.sh
[npm]: https://www.npmjs.com
[mas]: https://github.com/mas-cli/mas
[mackup]: https://github.com/lra/mackup
[#632]: https://github.com/lra/mackup/pull/632
[up]: #using-a-cloud-service-instead-of-github
[zsh-docs]: http://zsh.sourceforge.net/Doc
[zsh-docs-guide]: http://zsh.sourceforge.net/Guide/zshguide.html
[zsh-docs-startup_files]: http://zsh.sourceforge.net/Intro/intro_3.html
[zsh-docs-var_idex]: http://zsh.sourceforge.net/Doc/Release/Variables-Index.html
[zsh-docs-shell_grammar]: http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html
[archw-zsh]: https://wiki.archlinux.org/index.php/zsh
[XDG]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[issues]: https://github.com/nicolodiamante/dotfiles/issues
