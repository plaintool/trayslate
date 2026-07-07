//-----------------------------------------------------------------------------------
//  Toolkit Package © 2026 by Alexander Tverskoy
//  Licensed under the MIT License
//  You may obtain a copy of the License at https://opensource.org/licenses/MIT
//-----------------------------------------------------------------------------------
{
  Safe "setTimeout" implementation for Lazarus / FPC 3.2.2+
  No anonymous methods required – uses plain procedure of object.

  Usage:
  // Simple one-shot (no cancel needed):
  SetTimeout(500, @SomeMethod);

  // With auto-nilling variable – safe for ClearTimeout at any time:
  var MyTimer: TTimer;
  SetTimeoutSafe(MyTimer, 500, @SomeMethod);
  // MyTimer will become nil automatically as soon as the timer fires.

  // Cancel before firing:
  ClearTimeout(MyTimer);   // always safe, even if already fired
-----------------------------------------------------------------------------------}

unit OneShotTimer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, Forms;

type
  TOneShotCallback = procedure of object;

// Basic version – fire once, no external variable needed. Cannot be cancelled.
procedure SetTimeout(Delay: cardinal; Callback: TOneShotCallback);

// Legacy – returns a TTimer for cancellation, but you MUST manually nil your variable after firing.
// Use SetTimeoutSafe instead to avoid dangling pointers.
function SetTimeoutEx(Delay: cardinal; Callback: TOneShotCallback): TTimer;

// Safe version – the timer variable is automatically set to nil when the timer fires.
// ClearTimeout() can be called at any time without risk of Access Violation.
procedure SetTimeoutSafe(out Timer: TTimer; Delay: cardinal; Callback: TOneShotCallback);

// Cancel a pending timer. If the timer has already fired, it just sets the variable to nil.
// Always safe to call.
procedure ClearTimeout(var Timer: TTimer);

implementation

type
  TOneShotTimer = class(TTimer)
  private
    FCallback: TOneShotCallback;
    FUserVar: ^TTimer;            // pointer to the external TTimer variable
    procedure AsyncFree(Data: PtrInt);
  public
    // CreateWith now takes a var parameter, so the timer knows which variable to nil.
    constructor CreateWith(ADelay: cardinal; ACallback: TOneShotCallback; var ExtRef: TTimer);
    procedure TimerFire(Sender: TObject);
  end;

constructor TOneShotTimer.CreateWith(ADelay: cardinal; ACallback: TOneShotCallback; var ExtRef: TTimer);
begin
  inherited Create(nil);
  FCallback := ACallback;
  FUserVar := @ExtRef;          // remember address of the user's variable
  Interval := ADelay;
  OnTimer := @TimerFire;
  Enabled := True;
  ExtRef := Self;               // user's variable now points to this instance
end;

procedure TOneShotTimer.TimerFire(Sender: TObject);
begin
  Enabled := False;
  // Immediately nil the external variable so no one touches a dead object
  if FUserVar <> nil then
    FUserVar^ := nil;
  if Assigned(FCallback) then
    FCallback();
  // Schedule self-destruction after the event handler completes
  Application.QueueAsyncCall(@AsyncFree, PtrInt(Self));
end;

procedure TOneShotTimer.AsyncFree(Data: PtrInt);
begin
  TOneShotTimer(Data).Free;
end;

// Simple call, no way to cancel (the external variable is a dummy)
procedure SetTimeout(Delay: cardinal; Callback: TOneShotCallback);
var
  dummy: TTimer;
begin
  dummy := nil;   // suppress compiler hint
  TOneShotTimer.CreateWith(Delay, Callback, dummy);
end;

// Legacy function – returns timer, but user must manage the variable manually.
// Note: after firing, the returned pointer becomes invalid.
function SetTimeoutEx(Delay: cardinal; Callback: TOneShotCallback): TTimer;
begin
  Result := nil;  // suppress compiler hint
  TOneShotTimer.CreateWith(Delay, Callback, Result);
end;

// Safe function – the timer variable will be auto-nilled on fire.
procedure SetTimeoutSafe(out Timer: TTimer; Delay: cardinal; Callback: TOneShotCallback);
begin
  Timer := nil;   // suppress compiler hint
  TOneShotTimer.CreateWith(Delay, Callback, Timer);
end;

procedure ClearTimeout(var Timer: TTimer);
begin
  if Timer = nil then Exit;
  if Timer is TOneShotTimer then
  begin
    Timer.Enabled := False;
    TOneShotTimer(Timer).FUserVar := nil; // prevent AsyncFree from touching the user variable
    FreeAndNil(Timer);
  end
  else
    // It's some other kind of TTimer – just stop and free it
    FreeAndNil(Timer);
end;

end.
