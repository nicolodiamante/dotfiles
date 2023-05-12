<p align="center"><a href="#"><img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/ae1580af-21eb-4f01-b12d-2a6188d0988f" draggable="false" ondragstart="return false;" alt="Dotfiles Title" title="Dotfiles" /></a></p>

For those who are not familiar, the dotfiles directory is a hidden directory in the user's home directory that contains configuration files for various applications and tools. These files are typically preceded by a dot, hence the name "dotfiles". This project's shell scripts automate the installation of development tools, apps, and symbolic links, making it easy to automate and synchronise your configurations across multiple systems.
<br/><br/><br/><br/>


<p align="center"><a href="#"><img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/a95ba313-95e4-4a74-872c-4214cccd33d6" draggable="false" ondragstart="return false;" alt="iCloud Sync Status" title="iCloud Sync Status" width="700px" /></a></p>
<br/><br/><br/>

### Benefits of Dotfiles

- Saves time and effort by automating the installation of development tools.
- Ensures consistency across multiple systems by synchronizing configurations.
- Easy to set up and use.
<br/><br/>

## Using a cloud service instead of GitHub

As a member of the Apple ecosystem, I decided to streamline my workflow by moving my dotfiles to iCloud Drive. Since I'm already paying for an iCloud subscription, it made sense to take advantage of this cloud storage service to keep all my dotfiles in one place. Putting dotfiles into iCloud Drive can be a great way to keep them synced across all of your Apple devices. However, my latest configuration still remains on Github, allowing me to easily push or pull updates as I make them. This simple sync process ensures that you can keep all your systems in sync and access your dotfiles from anywhere. This streamlined workflow saves you time and effort, making it a convenient and accessible solution for managing your dotfiles.<br/><br/>

### What are the benefits of working in the Cloud?

Using a cloud service, like Dropbox, Google Drive, or iCloud Drive, can offer various advantages, especially when it comes to real-time syncing. By storing your dotfiles in the cloud, you can quickly and easily access and edit them from any device, without worrying about manually transferring the latest version. Additionally, you can maintain the same folder structure across all your devices, making it easier to organize and locate your files. You can even use Github as a backup and reference to share your repository with others. This approach ensures that you always have access to the latest version of your configuration, no matter where you are.<br/><br/>

<p align="center"><a href="#"><img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/26cf3dd9-297e-4cdd-a150-575eafc2cfdd" draggable="false" ondragstart="return false;" alt="iCloud Sync Status" title="iCloud Sync Status" width="560px" /></a></p><br/>

## Getting started

> Before incorporating someone else's dotfiles, it's recommended to review the code thoroughly to ensure that it's compatible with your system and to remove any unnecessary settings. Blindly using someone else's dotfiles without understanding what they do can lead to unintended consequences, so it's important to have a good understanding of what each configuration setting does before applying it to your system.

<br/>

### Installation

With the [Bootstrap script][bootstrap], you can easily manage and install packages using [Homebrew][brew], [npm][npm] and [mas][mas]. Once the packages are installed and configured, the macOS settings will be automatically set up for you. The script will then proceed to create a symbolic link of your dotfiles in your home directory, while keeping the original files intact in either iCloud Drive or in your local directory.

Let's get started, download the repository via curl:

```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nicolodiamante/dotfiles/HEAD/bootstrap.sh)"
```

The script will first attempt to clone the repository to `~/Library/Mobile Documents/com~apple~CloudDocs`, which is the path to the iCloud Drive directory for the user. If iCloud Drive is not available, the script will then clone the repository to `~` which is a local directory on the user's system.<br/><br/>

### Install Manually

As an alternative, you can download it first:

```shell
git clone https://github.com/nicolodiamante/dotfiles.git ~
```

Navigate to the dotfiles directory and execute the script.

```shell
cd bin && source bootstrap.sh
```

<p align="center"><a href="#"><img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/5b0d2bc2-764b-4f46-9def-ca692ecaa026" draggable="false" ondragstart="return false;" alt="Dotfiles Prompt" title="Dotfiles Prompt" width="590px" /></a></p>

<br/>

## Add custom commands without creating a new fork

The user/config feature allows users to add custom commands to their dotfiles without having to fork the entire repository. This is useful for adding commands that users do not want to commit to a public repository. Additionally, users can also create additional files in the user/ directory which will be sourced automatically from the zshrc file and ignored by Git. This provides users with more flexibility in managing their dotfiles and allows them to easily customize their shell environment to suit their needs. With this approach, users can keep their dotfiles organized and easily accessible, while also ensuring that their sensitive information remains private.
<br/><br/>

## Notes

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

Thanks for considering these Dotfiles for your development needs. If you have any ideas on how to improve this project, please feel free to share them. If you encounter any issues or bugs, please report them to the [issues page][issues]. Your feedback is valuable in helping to improve these Dotfiles.<br/><br/>

<p align="center"><a href="#"><img src="https://user-images.githubusercontent.com/48920263/113406768-5a164900-93ac-11eb-94a7-09377a52bf53.png" draggable="false" ondragstart="return false;" /></a></p>

<p align="center"><a href="https://nicolodiamante.com" target="_blank"><img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/22e1e41a-1906-4c27-8a92-85033943f0dd" draggable="false" ondragstart="return false;" alt="Nicol&#242; Diamante Portfolio" title="Nicol&#242; Diamante" width="11px" /></a></p>

<p align="center"><a href="https://github.com/nicolodiamante/dotfiles/blob/main/LICENSE.md" target="_blank"><img src="https://github.com/nicolodiamante/dotfiles/assets/48920263/caaf376c-6a76-4210-b341-11d6bedeb237" draggable="false" ondragstart="return false;" alt="The MIT License" title="The MIT License (MIT)" width="90px" /></a></p>

<!-- Link labels: -->
[bootstrap]: bootstrap.sh
[brew]: https://brew.sh
[npm]: https://www.npmjs.com
[mas]: https://github.com/mas-cli/mas
[zsh-docs]: http://zsh.sourceforge.net/Doc
[zsh-docs-guide]: http://zsh.sourceforge.net/Guide/zshguide.html
[zsh-docs-startup_files]: http://zsh.sourceforge.net/Intro/intro_3.html
[zsh-docs-var_idex]: http://zsh.sourceforge.net/Doc/Release/Variables-Index.html
[zsh-docs-shell_grammar]: http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html
[archw-zsh]: https://wiki.archlinux.org/index.php/zsh
[XDG]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
[issues]: https://github.com/nicolodiamante/dotfiles/issues
