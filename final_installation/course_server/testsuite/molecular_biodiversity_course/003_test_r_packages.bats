#!/usr/bin/env bats

@test "Check that package vegan exists" {
    run Rscript check_r_library.R vegan
    [ $status = 0  ]
}

@test "Check that package ade4 exists" {
    run Rscript check_r_library.R ade4
    [ $status = 0  ]
}

@test "Check that package phyloseq exists" {
    run Rscript check_r_library.R phyloseq
    [ $status = 0  ]
}

