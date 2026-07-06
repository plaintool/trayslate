//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit stringshelper;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LazUTF8;

type
  TStringsHelper = class helper for TStrings
  public
    // Searches for the first string containing SubText
    function FindInStringList(const SubText: string): integer;

    // Finds a name=value pair by its value part (case‑sensitive by default)
    function GetIndexByValue(const AValue: string; CaseSensitive: boolean = True): integer;

    // Removes all lines where '=' is followed by an empty value
    procedure RemoveEmptyValues;

    // Replaces AFrom with ATo in all strings; optionally replaces only the first occurrence
    procedure Replace(const AFrom, ATo: string; AReplaceAll: boolean = False);

    // Finds a name=value pair by its name (case‑insensitive)
    function IndexOfNameIgnoreCase(const AName: string): integer;

    // Searches for a string that matches AValue by exact name, exact value, or by parts after splitting
    function FindSubstringIndex(const AValue: string;const Seps: TSysCharSet = ['-','_',' ',':',',',';']): integer;

    // Returns True if any string in the list contains SubText
    function Any(const SubText: string): Boolean;

    // Returns True if the list contains value
    function Contains(const Value: string): Boolean;
 end;

implementation

function TStringsHelper.FindInStringList(const SubText: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
    if Pos(SubText, Self[i]) > 0 then
    begin
      Result := i;
      Exit;
    end;
end;

function TStringsHelper.GetIndexByValue(const AValue: string; CaseSensitive: boolean): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
    if (CaseSensitive and (Self.ValueFromIndex[i] = AValue)) or (not CaseSensitive and
      (UTF8CompareText(Self.ValueFromIndex[i], AValue) = 0)) then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TStringsHelper.RemoveEmptyValues;
var
  i: integer;
  EqualPos: integer;
begin
  // Traverse the list backwards so that deletions don't affect subsequent indices
  for i := Self.Count - 1 downto 0 do
  begin
    // Locate the position of the '=' character in the current line
    EqualPos := Pos('=', Self[i]);

    // If '=' exists and there is no text after it, remove the line
    if (EqualPos > 0) and (Copy(Self[i], EqualPos + 1, MaxInt) = string.Empty) then
      Self.Delete(i);
  end;
end;

procedure TStringsHelper.Replace(const AFrom, ATo: string; AReplaceAll: boolean);
var
  i: integer;
  Flags: TReplaceFlags;
begin
  if (AFrom = string.Empty) or (Self.Count = 0) then Exit;

  if AReplaceAll then
    Flags := [rfReplaceAll]
  else
    Flags := []; // replace only first occurrence

  for i := 0 to Self.Count - 1 do
  begin
    // Check first to avoid unnecessary StringReplace
    if Pos(AFrom, Self[i]) > 0 then
    begin
      Self[i] := StringReplace(Self[i], AFrom, ATo, Flags);

      // If only one replacement needed — exit after first match
      if not AReplaceAll then
        Exit;
    end;
  end;
end;

function TStringsHelper.IndexOfNameIgnoreCase(const AName: string): integer;
var
  I: integer;
begin
  for I := 0 to Self.Count - 1 do
    if SameText(Self.Names[I], AName) then
      Exit(I);

  Result := -1;
end;

function TStringsHelper.FindSubstringIndex(const AValue: string; const Seps: TSysCharSet = ['-','_',' ',':',',',';']): integer;
var
  Parts: TStringArray;
  Part: string;
  CharSet: set of Char absolute Seps;
  SepStr: string;
begin
  Result := -1;
  if (Self.Count = 0) or (AValue = string.Empty) then
    Exit;

  // Search by Name (exact, case-sensitive)
  Result := Self.IndexOfName(AValue);
  if Result >= 0 then
    Exit;

  // Search by Value (using our helper method)
  Result := Self.GetIndexByValue(AValue);
  if Result >= 0 then
    Exit;

  SepStr := string.Empty;
  for Part in CharSet do
    SepStr := SepStr + Part;

  // Try to split by common delimiters and search each part
  Parts := AValue.Split(SepStr.ToCharArray);
  for Part in Parts do
  begin
    if Part = string.Empty then
      Continue;

    // Search split part by Name
    Result := Self.IndexOfName(Part);
    if Result >= 0 then
      Exit;

    // Search split part by Value
    Result := Self.GetIndexByValue(Part);
    if Result >= 0 then
      Exit;
  end;

  Result := -1;
end;

function TStringsHelper.Any(const SubText: string): Boolean;
begin
  Result := FindInStringList(SubText) >= 0;
end;

function TStringsHelper.Contains(const Value: string): Boolean;
begin
  Result := Self.IndexOf(Value) >= 0;
end;

end.
