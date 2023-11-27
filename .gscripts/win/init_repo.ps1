# Set main and backup directory paths
$MAIN_DIR = "$HOME\.gdot"
$BACKUP_DIR = "$HOME\.gdot_backup"

Set-Location $HOME

git clone --bare https://github.com/gplusplus314/gdot .gdot

Remove-Item $MAIN_DIR -Recurse -Force -ErrorAction SilentlyContinue

git clone --bare https://github.com/gplusplus314/gdot $MAIN_DIR

function gdot {
    & git --git-dir=$MAIN_DIR --work-tree=$HOME @args
}

function doCheckout {
    gdot checkout
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Checked out gdot dotfiles..."
    } else {
        Write-Output "Backing up pre-existing dotfiles."
        $FILES = gdot checkout 2>&1 | Select-String -Pattern "^\s+(\S+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
        foreach ($FILE in $FILES) {
            $DIR = [System.IO.Path]::GetDirectoryName($FILE)
            New-Item -ItemType Directory -Path "$BACKUP_DIR\$DIR" -Force
            Move-Item $FILE "$BACKUP_DIR\$FILE" -Force
        }
        doCheckout
    }
}
doCheckout

# Configure git to not show untracked files
gdot config status.showUntrackedFiles no

