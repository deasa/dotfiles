# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/brendan.ashton/.oh-my-zsh"
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/Applications/GoLand.app/Contents/MacOS"
export GOPRIVATE="weavelab.xyz/*"
export GOROOT="/usr/local/go/"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes 
ZSH_THEME="Soliah"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  kubectl
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.bash_profile
source <(bart completion zsh)
source ~/.zshenv

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/brendan.ashton/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/brendan.ashton/Downloads/google-cloud-sdk/path.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Kubernetes
alias kd='kubectl --context=wsf-dev-0-gke1-west4'
alias kg='kubectl --context=gke1-west3'
alias kdd='kubectl --context=wsf-dev-0-gke1-west4 -n devx'
alias kgd='kubectl --context=gke1-west3 -n devx'
alias kds='kubectl --context=wsf-dev-0-gke1-west4 -n sync-apps'
alias kgs='kubectl --context=gke1-west3 -n sync-apps'
alias kdt='kubectl --context=wsf-dev-0-gke1-west4 -n test-infra'
alias kgt='kubectl --context=gke1-west3 -n test-infra'
kdtpod () { kubectl --context=wsf-dev-0-gke1-west4 -n test-infra get pods --template '{{range .items}}{{.metadata.name}}{{end}}' --selector=app="${1}";}
execToPod () { kubectl --context=wsf-dev-0-gke1-west4 -n test-infra "$(kdtpod $1)" -c "$1" --/bin/bash;}
getTASJobs() {
    if [ -z "$1" ]; then
        echo "Please provide the namespace."
        return 1
    fi 

    local namespace="$1"
    
    kubectl --context=wsf-dev-0-gke1-west4 -n ${namespace} get jobs --sort-by=.metadata.creationTimestamp | grep tas
}
getTASJobLogs() {
    if [ -z "$1" ]; then
        echo "Please provide the namespace."
        return 1
    fi
    if [ -z "$2" ]; then
        echo "Please provide the job name."
        return 1
    fi
    
    local namespace="$1"
    local job_name="$2"

    kubectl --context=wsf-dev-0-gke1-west4 -n ${namespace} logs job/${job_name}
}
alias kdsDeleteIntegrationTestingPods='for x in $(kubectl --context=wsf-dev-0-gke1-west4 -n=sync-apps get pods -o name | grep integration-testing); do kubectl --context=wsf-dev-0-gke1-west4 -n=sync-apps delete "$x"; done'
alias kdsDeleteIntegrationTestingSS='for x in $(kubectl --context=wsf-dev-0-gke1-west4 -n=sync-apps get statefulset -o name | grep integration-testing); do kubectl --context=wsf-dev-0-gke1-west4 -n=sync-apps delete "$x"; done'
alias kdsDeleteIntegrationTestingPvcs='for x in $(kubectl --context=wsf-dev-0-gke1-west4 -n=sync-apps get pvc -o name | grep integration-testing); do kubectl --context=wsf-dev-0-gke1-west4 -n=sync-apps delete "$x"; done'

# Git
alias gs='git status'
alias glo='git log --graph --oneline --decorate'
alias ga='git add'
alias gc='git commit'
alias gch='git checkout'
alias gcAmend='git add . && git commit --amend --no-edit'
alias gp='git push'
alias gpup='git push -u origin'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gmaster='git checkout master'
alias gmain='git checkout main'
alias gpAndWatch='git push && bart builds -w'
alias gpfAndWatch='git push --force-with-lease && bart builds -w'
alias gitRebaseMain='git checkout main && \
    git pull && \
    git checkout - && \
    git rebase main'
git-fixup ()      { git commit --fixup HEAD; }
git-fixup-all ()  { git add -A && git commit --fixup HEAD; }
git-autosquash () { GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash ${1:-origin/main}; }
auto-fixup ()     { git-fixup-all; git-autosquash; }
git-recommit () {
    date > .gitrecommit
    git add .gitrecommit
    git-fixup
    git rm .gitrecommit
    git-fixup
    git-autosquash
}
git-fetchandpull () {
    FOUND=$(find . -type d -name .git)
    if [[ -n $FOUND ]];then
        echo "Running git fetch and pull"
        git fetch
        git pull
    fi
}

# Go
alias lintAndCommit='golangci-lint run --enable=gofmt && git commit -am'
updateDep() {
  if [ -z "$1" ]; then
    echo "Please provide the dependency name."
    return 1
  fi

  local dep_name="$1"
  local today_date=$(date +"%m%d%y")
  local branch_name="brendan-update-${dep_name}-${today_date}"

  git checkout main
  git pull
  git checkout -b "$branch_name"
  go get "weavelab.xyz/${dep_name}"
  go mod tidy
  git commit -am "chore: update dependency ${dep_name}"
  git push -u origin "$branch_name"
}
goGetWeave() {
    if [ -z "$1" ]; then
        echo "Please provide the dependency name."
        return 1
    fi

    local dep_name="$1"
    
    go get "weavelab.xyz/${dep_name}"
    go mod tidy
}

# Misc
alias ll='ls -lah'
alias wdev='cd ~/go/src/weavelab.xyz/'
alias updateSyncApp='cd ~/go/src/weavelab.xyz/sync-app/dev/scripts ; ./update-single-cloud-sync-app.sh'
alias upSource='source ~/.bash_profile'
alias grpcProxy='cd ~/go/src/github.com/jnewmano/grpc-json-proxy ; ./grpc-json-proxy'
alias bashProfile='code ~/.bash_profile'
alias rm='rm -i'
alias decodeAndJq='pbpaste | base64 --decode | jq .'
alias decode='pbpaste | base64 --decode'
alias dsaKey="export DATA_SEEDING_API_KEY=$(bart test env secrets --cluster=wsf-dev-0-gke1-west4 | awk -F":" '{print $2}' | awk '{print $NF}')"
alias countLinesRecursive="( find ./ -name '*.go' -print0 | xargs -0 cat ) | wc -l"

# Docker
alias ubuntu='docker run -it -v $(pwd):/usr/src/project ubuntu:latest'

# DB
alias cloudSQLProxy_dev0_2a='cloud_sql_proxy -instances=wsf-dev-0:us-west4:pgsql-west4-dev0-2a=tcp:5432'
alias bartDBTestInfra='bart database proxy --listen=localhost:5432 --instance=wsf-dev-0:us-west4:pgsql-west4-dev0-2a --database=test_infra'
alias bartDBDevX='bart database proxy --listen=localhost:5432 --instance=wsf-dev-0:us-west4:pgsql-west4-dev0-2a --database=devx'

bartDB() {
    if [ -z "$1" ]; then
        echo "Please provide the database name."
        return 1
    fi
    if [ -z "$2" ]; then
        echo "Please provide the schema name."
        return 1
    fi

    local database="$1"
    local schema="$2"
    
    bart database proxy --listen=localhost:5432 --instance=wsf-dev-0:us-west4:pgsql-west4-dev0-2a --database=${database} --schema=${schema}
}