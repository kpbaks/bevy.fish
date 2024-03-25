function bevy-plugins -d ''
    set -l options h/help
    if not argparse $options -- $argv
        printf '\n'
        eval (status function) --help
        return 2
    end

    if set --query _flag_help
        set -l option_color (set_color $fish_color_option)
        set -l reset (set_color normal)
        set -l bold (set_color --bold)
        set -l section_header_color (set_color yellow)

        printf '%sdescription%s\n' $bold $reset
        printf '\n'
        printf '%sUSAGE:%s %s%s%s [OPTIONS]\n' $section_header_color $reset (set_color $fish_color_command) (status function) $reset
        printf '\n'
        printf '%sOPTIONS:%s\n' $section_header_color $reset
        printf '%s\t%s-h%s, %s--help%s Show this help message and return\n'
        # printf '%sEXAMPLES:%s\n' $section_header_color $reset
        # printf '\t%s%s\n' (printf (echo "$(status function)" | fish_indent --ansi)) $reset
        return 0
    end >&2

    if not command --query rg
        return 1
    end

    if test $PWD = $HOME
        return 2
    end

    if not test -f Cargo.toml
        return 2
    end

    set -l rg_opts --pretty --smart-case --pcre2-unicode --vimgrep
    set -l re '^impl\s+Plugin\s+for\s+(\S+)'
    command rg $rg_opts "$re"

    return 0
end
