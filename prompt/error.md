Resolve-Path : Cannot find path 
'C:\Users\Tata\dev\chest-of-drawers-bookcase\export\H2300xW600xD230_Mm19_Ms12\dxf-raw\CorpusSideLeft.dxf' because it   
does not exist.
At C:\Users\Tata\dev\chest-of-drawers-bookcase\ps-modules\CommonFunctions.psm1:45 char:24
+     $resolvedTarget = (Resolve-Path -Path $TargetPath).ProviderPath
+                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\Users\Tata\d...pusSideLeft.dxf:String) [Resolve-Path], ItemNotFound  
   Exception
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.ResolvePathCommand

Exception calling "MakeRelativeUri" with "1" argument(s): "Value cannot be null.
Parameter name: uri"
At C:\Users\Tata\dev\chest-of-drawers-bookcase\ps-modules\CommonFunctions.psm1:57 char:5
+     $relativePathUri = $baseUri.MakeRelativeUri($targetUri)
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException
    + FullyQualifiedErrorId : ArgumentNullException

You cannot call a method on a null-valued expression.
At C:\Users\Tata\dev\chest-of-drawers-bookcase\ps-modules\CommonFunctions.psm1:58 char:5
+     $relativePath = [System.Uri]::UnescapeDataString($relativePathUri ...
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [], RuntimeException
    + FullyQualifiedErrorId : InvokeMethodOnNull

Exporting 