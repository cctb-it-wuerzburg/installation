#!/usr/bin/env bats

@test "Check that user alekel exists" {
    run id alekel
    [ $status = 0  ]
}

@test "Check that user marank exists" {
    run id marank
    [ $status = 0  ]
}
