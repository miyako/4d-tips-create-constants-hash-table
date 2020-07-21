//%attributes = {}
/*
Can I get the name of 4D constants, modifiers or key codes?
https://discuss.4d.com/t/can-i-get-the-name-of-4d-constants-modifiers-or-key-codes/14810
*/

$lang:=Get database localization:C1009(Default localization:K5:21)

$xlf:=Folder:C1567(Application file:C491;fk platform path:K87:2)\
.folder("Contents")\
.folder("Resources")\
.folder($lang+".lproj")\
.file("4D_Constants"+Uppercase:C13($lang;*)+".xlf")

ASSERT:C1129($xlf.exists)

$dom:=DOM Parse XML source:C719($xlf.platformPath)

C_OBJECT:C1216($constants)
$constants:=New object:C1471
C_COLLECTION:C1488($constantIds)
$constantIds:=New collection:C1472

C_TEXT:C284($stringValue;$id;$value)

ARRAY LONGINT:C221($pos;0)
ARRAY LONGINT:C221($len;0)

If (OK=1)
	ARRAY TEXT:C222($groups;0)
	$group:=DOM Find XML element:C864($dom;"xliff/file/body/group";$groups)
	If (OK=1)
		For ($i;1;Size of array:C274($groups))
			$group:=$groups{$i}
			ARRAY TEXT:C222($transUnits;0)
			$transUnit:=DOM Find XML element:C864($group;"group/trans-unit";$transUnits)
			For ($ii;1;Size of array:C274($transUnits))
				
				$transUnit:=$transUnits{$ii}
				DOM GET XML ATTRIBUTE BY NAME:C728($transUnit;"id";$id)
				
				Case of 
					: ($i=1)
						
						DOM GET XML ATTRIBUTE BY NAME:C728($group;"resname";$stringValue)
						ASSERT:C1129($stringValue="ConstantThemes")
						
						$source:=DOM Find XML element:C864($transUnit;"trans-unit/source")
						DOM GET XML ELEMENT VALUE:C731($source;$stringValue)  //get group name
						
						Case of 
							: (Match regex:C1019("\\d+";$id))
								$constantValues:=New object:C1471
								$constants[$stringValue]:=$constantValues  //hash table of group names
								$constantIds[Num:C11($id)]:=$stringValue  //use this to convert group id to group name
							Else 
								TRACE:C157
						End case 
						
					Else 
						
						DOM GET XML ATTRIBUTE BY NAME:C728($group;"restype";$stringValue)
						ASSERT:C1129($stringValue="x-4DK#")
						
						Case of 
							: (DOM Count XML attributes:C727($transUnit)<2)  //87_6
							Else 
								DOM GET XML ATTRIBUTE BY NAME:C728($transUnit;"d4:value";$value)  //constant value
								If ($value#"")
									Case of 
										: (Match regex:C1019("\\d+_(\\d+)";$id;1;$pos;$len))
											
											DOM GET XML ATTRIBUTE BY NAME:C728($group;"d4:groupID";$stringValue)  //get group id
											
											C_OBJECT:C1216($constantValues)
											$constantValues:=$constants[$constantIds[Num:C11($stringValue)]]  //convert group id to group name
											
											$id:=Substring:C12($id;$pos{1};$len{1})  //get constant id
											
											$source:=DOM Find XML element:C864($transUnit;"trans-unit/source")
											DOM GET XML ELEMENT VALUE:C731($source;$stringValue)  //constant name
											
											Case of 
												: (Match regex:C1019("\\d+\\.?\\d*";$value;1;$pos;$len))
													$constantValues[$value]:=$stringValue
												: (Match regex:C1019("([^:]+):L|R";$value;1;$pos;$len))
													$constantValues[Substring:C12($value;$pos{1};$len{1})]:=$stringValue
												: (Match regex:C1019("([^:]+):S";$value;1;$pos;$len))
													$constantValues[Substring:C12($value;$pos{1};$len{1})]:=$stringValue
												Else 
													$constantValues[$value]:=$stringValue
											End case 
											
										Else 
											TRACE:C157
									End case 
								End if 
						End case 
				End case 
			End for 
		End for 
	End if 
	DOM CLOSE XML:C722($dom)
End if 

$constant:=$constants["Events (Modifiers)"]["256"]
