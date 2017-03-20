#!/usr/bin/env bats

@test "Check that R is installed" {
    command -v R
}

@test "Check that rstudio is installed" {
    command -v rstudio
}

@test "Check that fastqc is installed" {
    command -v fastqc
}

@test "Check that seaview is installed" {
    command -v seaview
}

@test "Check that figtree is installed" {
    command -v figtree
}

@test "Check that usearch is installed" {
    command -v usearch8
}

@test "Check that raxmlHPC is installed" {
    command -v raxmlHPC
}

@test "Check that blastn is installed" {
    command -v blastn
}

@test "Check that profdist_qt is installed" {
    command -v profdist_qt
}
