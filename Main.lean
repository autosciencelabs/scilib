import Lean
import Scilib

open Lean Widget

def main : IO Unit := IO.println s!"Hello!"

@[widget_module]
def helloWidget : Widget.Module where
  javascript := "
    import * as React from 'react';
    export default function(props) {
      const name = props.name || 'world'
      return React.createElement('p', {}, 'Hello ' + name + '!')
    }"
#widget helloWidget
