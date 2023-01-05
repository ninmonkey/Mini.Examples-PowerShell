$yamlContent = @'
PipeScript: |
{
@{a='b'}
}
List:
- PipeScript: |
  {
    @{a='b';k2='v';k3=@{k='v'}}
  }
- PipeScript: |
  {
    @(@{a='b'}, @{c='d'})
  }      
- PipeScript: |
  {
    @{a='b'}, @{c='d'}
  }
'@

[OutputFile('.\YAML.output.yaml')]$yamlContent

