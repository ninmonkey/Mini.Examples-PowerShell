using namespace System.Threading

#  https://xkln.net/blog/multithreading-in-powershell--running-a-specific-number-of-threads/

try {
    $threads = 10
    $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $threads)
    $RunspacePool.Open()
    $runspace = foreach ($i in 1..10) {
        $ps = [powershell]::Create().AddScript({
                param($i)
                "Hello from runspace $i"
                Start-Sleep (Get-Random -Maximum 10)
            }).AddParameters(@{i = $i })
        $ps.RunspacePool = $RunspacePool

        [pscustomobject]@{
            Instance = $ps
            Handle   = $ps.BeginInvoke()
        }
    }

    do {
        $shouldWait = [WaitHandle]::WaitAny($runspace.Handle.AsyncWaitHandle, 200)
    } while ($shouldWait)

    foreach ($r in $runspace) {
        $r.Instance.EndInvoke($r.Handle)
        $r.Instance.foreach('Dispose')
    }
} finally {
    $runspace.foreach('Clear')
    $RunspacePool.foreach('Dispose')
}
