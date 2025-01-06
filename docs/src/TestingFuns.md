# TestingFuns Module

This module provides functionality to define and execute unit tests for the replication package 
of Mahmood & Jetter (2023). It ensures that the replication pipeline performs as expected and 
produces consistent results.

## Overview

The `TestingFuns` module is designed to validate the functionality of the package by running 
unit tests that check for correctness in data wrangling, table generation, and figure replication. 
This helps ensure that the methods used in the Mahmood & Jetter (2023) replication are robust and reliable.

## Exports

The module provides the following key function:
- `run_tests`: Executes the full suite of tests for the package.

## Usage

```julia
using TestingFuns

# Run all unit tests
run_tests()
```