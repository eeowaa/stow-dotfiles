# Run a PowerShell script from standard input as an administrator
#
# NOTES:
# - Commands provided on STDIN must be terminated with semicolons,
#   even if they are terminated by newlines (either LF or CRLF).
#
# - If there is a fix for the above issue, I'm guessing it has to do
#   with the encoding of the command text passed to the -EncodedCommand
#   argument of powershell.exe in the wrapper script.
#
runas() {
    # Write standard input to a script file
    local script=$(mktemp)
    cat >"${script}"
    echo '; Read-Host -Prompt "Press ENTER to exit"' >>"${script}"

    # Move the script into %TEMP% and give it a .ps1 extension
    local tmpdir=$(wslpath $(wslvar --sys TEMP))
    mv "${script}" "${tmpdir}/${script##*/}.ps1"
    script=${tmpdir}/${script##*/}.ps1

    # Create a bootstrapping wrapper script
    local wrapper=$(mktemp)
    local scriptpath=$(wslpath -w "${script}")
    cat >"${wrapper}" <<EOF
\$content = Get-Content "${scriptpath}"
\$bytes = [System.Text.Encoding]::Unicode.GetBytes(\$content)
\$encoded = [System.Convert]::ToBase64String(\$bytes)
Start-Process \`
    -FilePath powershell.exe \`
    -ArgumentList "-EncodedCommand","\$encoded" \`
    -Verb RunAs -Wait
EOF

    # Add a .ps1 extension to wrapper script and run it
    mv "${wrapper}" "${wrapper}.ps1"
    wrapper=${wrapper}.ps1
    powershell.exe -File "${wrapper}"

    # Remove the temporary script files
    rm -f "${script}" "${wrapper}"
}
