# Matugen theme for Kakoune

declare-option str black default
declare-option str dark 'rgb:{{ colors.surface_container_lowest.default.hex_stripped }}'
declare-option str surface 'rgb:{{ colors.surface_container.default.hex_stripped }}'
declare-option str surface_high 'rgb:{{ colors.surface_container_high.default.hex_stripped }}'
declare-option str gray 'rgb:{{ colors.outline.default.hex_stripped }}'
declare-option str dimgray 'rgb:{{ colors.outline_variant.default.hex_stripped }}'
declare-option str white 'rgb:{{ colors.on_surface.default.hex_stripped }}'

declare-option str primary 'rgb:{{ colors.primary.default.hex_stripped }}'
declare-option str on_primary 'rgb:{{ colors.on_primary.default.hex_stripped }}'
declare-option str primary_container 'rgb:{{ colors.primary_container.default.hex_stripped }}'
declare-option str on_primary_container 'rgb:{{ colors.on_primary_container.default.hex_stripped }}'

declare-option str secondary 'rgb:{{ colors.secondary.default.hex_stripped }}'
declare-option str on_secondary 'rgb:{{ colors.on_secondary.default.hex_stripped }}'
declare-option str secondary_container 'rgb:{{ colors.secondary_container.default.hex_stripped }}'

declare-option str tertiary 'rgb:{{ colors.tertiary.default.hex_stripped }}'
declare-option str on_tertiary 'rgb:{{ colors.on_tertiary.default.hex_stripped }}'
declare-option str tertiary_container 'rgb:{{ colors.tertiary_container.default.hex_stripped }}'

declare-option str error 'rgb:{{ colors.error.default.hex_stripped }}'
declare-option str on_error 'rgb:{{ colors.on_error.default.hex_stripped }}'

declare-option str psel 'rgba:{{ colors.primary.default.hex_stripped }}40'
declare-option str ssel 'rgba:{{ colors.secondary.default.hex_stripped }}30'

declare-option str background %opt{black}
declare-option str foreground %opt{white}

set-face global value "%opt{tertiary}"
set-face global type "%opt{tertiary}+b"
set-face global variable "%opt{white}"
set-face global module "%opt{secondary}"
set-face global function "%opt{primary}+b"
set-face global string "%opt{secondary}"
set-face global keyword "%opt{primary}+b"
set-face global operator "%opt{tertiary}"
set-face global attribute "%opt{secondary}"
set-face global bracket "%opt{white}+b"
set-face global arguement "%opt{tertiary}"
set-face global comma "%opt{white}"
set-face global comment "%opt{gray}+i"
set-face global docstring "%opt{gray}+i"
set-face global meta "%opt{secondary}"
set-face global builtin "%opt{primary}+b"
set-face global class "%opt{primary}+b"
set-face global self "%opt{tertiary}"
set-face global constant "%opt{tertiary}+b"

set-face global title "%opt{primary}+b"
set-face global header "%opt{secondary}+b"
set-face global bold "%opt{primary}+b"
set-face global italic "%opt{tertiary}+i"
set-face global mono "%opt{secondary}"
set-face global block "%opt{tertiary}"
set-face global link "%opt{primary}"
set-face global bullet "%opt{primary}"
set-face global list "%opt{white}"

set-face global Default "%opt{white},%opt{black}"
set-face global PrimarySelection "default,%opt{psel}"
set-face global SecondarySelection "default,%opt{ssel}"
set-face global PrimaryCursor "%opt{dark},%opt{primary}+b"
set-face global SecondaryCursor "%opt{dark},%opt{secondary}+b"
set-face global PrimaryCursorEol "%opt{dark},%opt{tertiary}"
set-face global SecondaryCursorEol "%opt{dark},%opt{secondary}"

set-face global LineNumbers "%opt{gray},%opt{black}"
set-face global LineNumberCursor "%opt{primary},%opt{black}+b"
set-face global LineNumbersWrapped "%opt{dimgray},%opt{black}+i"
set-face global MenuForeground "%opt{on_primary_container},%opt{primary_container}+b"
set-face global MenuBackground "%opt{white},%opt{surface}"
set-face global MenuInfo "%opt{secondary},%opt{surface}"
set-face global Information "%opt{white},%opt{surface_high}"
set-face global Error "%opt{on_error},%opt{error}+b"

set-face global StatusLine "%opt{white},%opt{surface}"
set-face global StatusLineMode "%opt{primary},%opt{surface}+b"
set-face global StatusLineInfo "%opt{tertiary},%opt{surface}"
set-face global StatusLineValue "%opt{secondary},%opt{surface}"
set-face global StatusCursor "%opt{dark},%opt{primary}+b"
set-face global Prompt "%opt{primary},%opt{surface}+b"

set-face global MatchingChar "%opt{primary},%opt{black}+b"
set-face global Whitespace "%opt{dimgray},%opt{black}+f"
set-face global WrapMarker Whitespace
set-face global BufferPadding "%opt{dimgray},%opt{black}"
