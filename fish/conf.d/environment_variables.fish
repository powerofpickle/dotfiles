set script_path (realpath (status --current-filename))
set dotfiles_dir (dirname (dirname (dirname "$script_path")))

set env_vars_script "$dotfiles_dir/scripts/environment_variables.sh"

function set_env_from_stdin
    while read -l line
        # Skip empty lines and comments
        if test -z "$line" -o (string sub -l 1 "$line") = "#"
            continue
        end

        # Split on the first = sign
        set -l var_name (string split -m 1 "=" "$line")[1]
        set -l var_value (string split -m 1 "=" "$line")[2]

        # Check if we have both name and value
        if test -n "$var_name" -a -n "$var_value"
            # Set the environment variable
            set -gx $var_name $var_value
        else if test -n "$var_name" -a -z "$var_value"
            # Handle case where value is empty (VAR_NAME=)
            set -gx $var_name ""
        end
    end
end

sh "$env_vars_script" | set_env_from_stdin
