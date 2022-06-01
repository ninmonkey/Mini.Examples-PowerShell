using namespace System.Management.Automation.Language

$About = @{
    Description = 'Enumerate AST using a [ICustomAstVisitor2] interface'
    Tags        = @('Ast', 'ICustomAstVisitor2')
    Source      = 'https://gist.github.com/SeeminglyScience/aa32532ced05c7e441b498c234177547'
    Links       = @(
        'https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.language.icustomastvisitor2?view=powershellsdk-7.0.0'
    )
}


class Visitor : ICustomAstVisitor2 {
    [string] $currentFunction

    [System.Collections.Generic.List[object]] $list = [System.Collections.Generic.List[object]]::new()

    static [object[]] GetParameters([Ast] $ast) {
        $visitor = [Visitor]::new()
        $ast.Visit($visitor)
        return $visitor.list.ToArray()
    }

    [Object] VisitFunctionDefinition([FunctionDefinitionAst] $functionDefinitionAst) {
        $old = $this.currentFunction
        try {
            $this.currentFunction = $functionDefinitionAst.Name
            foreach ($p in $functionDefinitionAst.Parameters) {
                $p.Visit($this)
            }

            return $functionDefinitionAst.Body.Visit($this)
        } finally {
            $this.currentFunction = $old
        }
    }

    [Object] VisitParameter([ParameterAst] $parameterAst) {
        if ($this.currentFunction) {
            $this.List.Add(
                [PSCustomObject]@{
                    Function  = $this.currentFunction
                    Parameter = $parameterAst.Name.VariablePath.UserPath
                    # etc
                })
        }

        return $parameterAst.DefaultValue?.Visit($this)
    }

    [Object] VisitScriptBlockExpression([ScriptBlockExpressionAst] $scriptBlockExpressionAst) {
        $old = $this.currentFunction
        try {
            $this.currentFunction = $null
            return $scriptBlockExpressionAst.ScriptBlock.Visit($this)
        } finally {
            $this.currentFunction = $old
        }
    }

    [Object] VisitPipeline([PipelineAst] $pipelineAst) {
        foreach ($element in $pipelineAst.PipelineElements) {
            $element.Visit($this)
        }

        return $null
    }

    [Object] VisitTypeDefinition([TypeDefinitionAst] $typeDefinitionAst) {
        foreach ($m in $typeDefinitionAst.Members) {
            $m.Visit($this)
        }

        return $null
    }

    [Object] VisitPropertyMember([PropertyMemberAst] $propertyMemberAst) {
        return $propertyMemberAst.InitialValue?.Visit($this)
    }

    [Object] VisitFunctionMember([FunctionMemberAst] $functionMemberAst) {
        return $functionMemberAst.Body.Visit($this)
    }

    [Object] VisitBaseCtorInvokeMemberExpression([BaseCtorInvokeMemberExpressionAst] $baseCtorInvokeMemberExpressionAst) {
        foreach ($a in $baseCtorInvokeMemberExpressionAst.Arguments) {
            $a.Visit($this)
        }

        return $null
    }

    [Object] VisitUsingStatement([UsingStatementAst] $usingStatement) {
        return $null
    }
    [Object] DefaultVisit([Ast] $ast) {
        throw [NotImplementedException]::new()
    }
    [Object] VisitErrorStatement([ErrorStatementAst] $errorStatementAst) {
        throw [NotImplementedException]::new()
    }
    [Object] VisitErrorExpression([ErrorExpressionAst] $errorExpressionAst) {
        throw [NotImplementedException]::new()
    }

    [Object] VisitConfigurationDefinition([ConfigurationDefinitionAst] $configurationDefinitionAst) {
        $configurationDefinitionAst.InstanceName.Visit($this)
        return $configurationDefinitionAst.Body.Visit($this)
    }

    [Object] VisitDynamicKeywordStatement([DynamicKeywordStatementAst] $dynamicKeywordAst) {
        foreach ($ce in $dynamicKeywordAst.CommandElements) {
            $ce.Visit($this)
        }

        return $null
    }

    [Object] VisitTernaryExpression([TernaryExpressionAst] $ternaryExpressionAst) {
        $ternaryExpressionAst.Condition.Visit($this)
        $ternaryExpressionAst.IfTrue.Visit($this)
        $ternaryExpressionAst.IfFalse.Visit($this)
        return $null
    }

    [Object] VisitPipelineChain([PipelineChainAst] $statementChainAst) {
        $statementChainAst.LhsPipelineChain.Visit($this)
        $statementChainAst.RhsPipeline.Visit($this)
        return $null
    }

    [Object] VisitScriptBlock([ScriptBlockAst] $scriptBlockAst) {
        $scriptBlockAst.ParamBlock?.Visit($this)
        $scriptBlockAst.DynamicParamBlock?.Visit($this)
        $scriptBlockAst.BeginBlock?.Visit($this)
        $scriptBlockAst.ProcessBlock?.Visit($this)
        $scriptBlockAst.EndBlock?.Visit($this)
        $scriptBlockAst.CleanBlock?.Visit($this)
        return $null
    }

    [Object] VisitParamBlock([ParamBlockAst] $paramBlockAst) {
        foreach ($p in $paramBlockAst.Parameters) {
            $p.Visit($this)
        }

        return $null
    }

    [Object] VisitNamedBlock([NamedBlockAst] $namedBlockAst) {
        foreach ($s in $namedBlockAst.Statements) {
            $s.Visit($this)
        }

        foreach ($t in $namedBlockAst.Traps) {
            $t.Visit($this)
        }

        return $null
    }

    [Object] VisitTypeConstraint([TypeConstraintAst] $typeConstraintAst) {
        return $null
    }

    [Object] VisitAttribute([AttributeAst] $attributeAst) {
        return $null
    }

    [Object] VisitNamedAttributeArgument([NamedAttributeArgumentAst] $namedAttributeArgumentAst) {
        return $null
    }

    [Object] VisitStatementBlock([StatementBlockAst] $statementBlockAst) {
        foreach ($s in $statementBlockAst.Statements) {
            $s.Visit($this)
        }

        return $null
    }

    [Object] VisitIfStatement([IfStatementAst] $ifStmtAst) {
        foreach ($c in $ifStmtAst.Clauses) {
            $c.Item1.Visit($this)
            $c.Item2.Visit($this)
        }

        return $ifStmtAst.ElseClause?.Visit($this)
    }

    [Object] VisitTrap([TrapStatementAst] $trapStatementAst) {
        return $trapStatementAst.Body.Visit($this)
    }

    [Object] VisitSwitchStatement([SwitchStatementAst] $switchStatementAst) {
        $switchStatementAst.Condition.Visit($this)
        foreach ($c in $switchStatementAst.Clauses) {
            $c.Item1.Visit($this)
            $c.Item2.Visit($this)
        }

        return $switchStatementAst.Default?.Visit($this)
    }

    [Object] VisitDataStatement([DataStatementAst] $dataStatementAst) {
        throw [NotImplementedException]::new()
    }

    [Object] VisitForEachStatement([ForEachStatementAst] $forEachStatementAst) {
        $forEachStatementAst.Condition.Visit($this)
        return $forEachStatementAst.Body.Visit($this)
    }

    [Object] VisitDoWhileStatement([DoWhileStatementAst] $doWhileStatementAst) {
        $doWhileStatementAst.Condition.Visit($this)
        return $doWhileStatementAst.Body.Visit($this)
    }

    [Object] VisitForStatement([ForStatementAst] $forStatementAst) {
        $forStatementAst.Initializer?.Visit($this)
        $forStatementAst.Condition?.Visit($this)
        $forStatementAst.Iterator?.Visit($this)
        return $forStatementAst.Body?.Visit($this)
    }

    [Object] VisitWhileStatement([WhileStatementAst] $whileStatementAst) {
        $whileStatementAst.Condition?.Visit($this)
        return $whileStatementAst.Body.Visit($this)
    }

    [Object] VisitCatchClause([CatchClauseAst] $catchClauseAst) {
        return $catchClauseAst.Body.Visit($this)
    }

    [Object] VisitTryStatement([TryStatementAst] $tryStatementAst) {
        $tryStatementAst.Body.Visit($this)
        foreach ($c in $tryStatementAst.CatchClauses) {
            $c.Visit($this)
        }

        return $tryStatementAst.Finally?.Visit($this)
    }

    [Object] VisitBreakStatement([BreakStatementAst] $breakStatementAst) {
        return $null
    }

    [Object] VisitContinueStatement([ContinueStatementAst] $continueStatementAst) {
        return $null
    }

    [Object] VisitReturnStatement([ReturnStatementAst] $returnStatementAst) {
        return $returnStatementAst.Pipeline?.Visit($this)
    }

    [Object] VisitExitStatement([ExitStatementAst] $exitStatementAst) {
        return $exitStatementAst.Pipeline?.Visit($this)
    }

    [Object] VisitThrowStatement([ThrowStatementAst] $throwStatementAst) {
        return $throwStatementAst.Pipeline?.Visit($this)
    }

    [Object] VisitDoUntilStatement([DoUntilStatementAst] $doUntilStatementAst) {
        $doUntilStatementAst.Body.Visit($this)
        return $doUntilStatementAst.Condition.Visit($this)
    }

    [Object] VisitAssignmentStatement([AssignmentStatementAst] $assignmentStatementAst) {
        $assignmentStatementAst.Left.Visit($this)
        return $assignmentStatementAst.Right.Visit($this)
    }

    [Object] VisitCommand([CommandAst] $commandAst) {
        foreach ($ce in $commandAst.CommandElements) {
            $ce.Visit($this)
        }

        return $null
    }

    [Object] VisitCommandExpression([CommandExpressionAst] $commandExpressionAst) {
        return $commandExpressionAst.Expression.Visit($this)
    }

    [Object] VisitCommandParameter([CommandParameterAst] $commandParameterAst) {
        return $commandParameterAst.Argument?.Visit($this)
    }

    [Object] VisitFileRedirection([FileRedirectionAst] $fileRedirectionAst) {
        return $null
    }

    [Object] VisitMergingRedirection([MergingRedirectionAst] $mergingRedirectionAst) {
        return $null
    }

    [Object] VisitBinaryExpression([BinaryExpressionAst] $binaryExpressionAst) {
        $binaryExpressionAst.Left.Visit($this)
        return $binaryExpressionAst.Right.Visit($this)
    }

    [Object] VisitUnaryExpression([UnaryExpressionAst] $unaryExpressionAst) {
        return $unaryExpressionAst.Child.Visit($this)
    }

    [Object] VisitConvertExpression([ConvertExpressionAst] $convertExpressionAst) {
        return $convertExpressionAst.Child.Visit($this)
    }

    [Object] VisitConstantExpression([ConstantExpressionAst] $constantExpressionAst) {
        return $null
    }

    [Object] VisitStringConstantExpression([StringConstantExpressionAst] $stringConstantExpressionAst) {
        return $null
    }

    [Object] VisitSubExpression([SubExpressionAst] $subExpressionAst) {
        return $subExpressionAst.SubExpression.Visit($this)
    }

    [Object] VisitUsingExpression([UsingExpressionAst] $usingExpressionAst) {
        return $usingExpressionAst.SubExpression.Visit($this)
    }

    [Object] VisitVariableExpression([VariableExpressionAst] $variableExpressionAst) {
        return $null
    }

    [Object] VisitTypeExpression([TypeExpressionAst] $typeExpressionAst) {
        return $null
    }

    [Object] VisitMemberExpression([MemberExpressionAst] $memberExpressionAst) {
        $memberExpressionAst.Expression.Visit($this)
        return $memberExpressionAst.Member.Visit($this)
    }

    [Object] VisitInvokeMemberExpression([InvokeMemberExpressionAst] $invokeMemberExpressionAst) {
        $invokeMemberExpressionAst.Expression.Visit($this)
        $invokeMemberExpressionAst.Member.Visit($this)
        foreach ($a in $invokeMemberExpressionAst.Arguments) {
            $a.Visit($this)
        }

        return $null
    }

    [Object] VisitArrayExpression([ArrayExpressionAst] $arrayExpressionAst) {
        return $arrayExpressionAst.SubExpression.Visit($this)
    }

    [Object] VisitArrayLiteral([ArrayLiteralAst] $arrayLiteralAst) {
        foreach ($e in $arrayLiteralAst.Elements) {
            $e.Visit($this)
        }

        return $null
    }

    [Object] VisitHashtable([HashtableAst] $hashtableAst) {
        foreach ($kvp in $hashtableAst.KeyValuePairs) {
            $kvp.Item1.Visit($this)
            $kvp.Item2.Visit($this)
        }

        return $null
    }

    [Object] VisitParenExpression([ParenExpressionAst] $parenExpressionAst) {
        return $parenExpressionAst.Pipeline?.Visit($this)
    }

    [Object] VisitExpandableStringExpression([ExpandableStringExpressionAst] $expandableStringExpressionAst) {
        foreach ($e in $expandableStringExpressionAst.NestedExpressions) {
            $e.Visit($this)
        }

        return $null
    }

    [Object] VisitIndexExpression([IndexExpressionAst] $indexExpressionAst) {
        $indexExpressionAst.Target.Visit($this)
        return $indexExpressionAst.Index.Visit($this)
    }

    [Object] VisitAttributedExpression([AttributedExpressionAst] $attributedExpressionAst) {
        return $attributedExpressionAst.Child.Visit($this)
    }

    [Object] VisitBlockStatement([BlockStatementAst] $blockStatementAst) {
        return $blockStatementAst.Body.Visit($this)
    }
}
