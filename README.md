# swift-sim

Simulator package for building system simulation models.

## Components

Components form the system hierarchy.

## Models

Models are models of systems.
Models can be dataflow driven (input / output signals).
In addition, models support events.

## Connectors

Data flow is built using the `Input<T>` and `Output<T>` property wrappers.

## Inspiration

Parts of the designs here are inspired by SMP,
but this does not aim at complex UML projects with code generation.
The purpose here is to have something,
where it is practical to write models in pure Swift.
