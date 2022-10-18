{
  ********************************************************************************

  Github - https://github.com/dliocode/datavalidator

  ********************************************************************************

  MIT License

  Copyright (c) 2022 Danilo Lucas

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

  ********************************************************************************
}

unit Validator.Custom;

interface

uses
  DataValidator.ItemBase;

type
  TValidatorCustom = class(TDataValidatorItemBase, IDataValidatorItem)
  private
    FCustomExecute: TDataValidatorCustomValue;
    FCustomMessageExecute: TDataValidatorCustomValueMessage;
    FCustomMessage: TDataValidatorCustomMessage;
  public
    function Check: IDataValidatorResult;
    constructor Create(
      const ACustomExecute: TDataValidatorCustomValue;
      const ACustomMessageExecute: TDataValidatorCustomValueMessage;
      const ACustomMessage: TDataValidatorCustomMessage;
      const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
  end;

implementation

{ TValidatorCustom }

constructor TValidatorCustom.Create(
      const ACustomExecute: TDataValidatorCustomValue;
      const ACustomMessageExecute: TDataValidatorCustomValueMessage;
      const ACustomMessage: TDataValidatorCustomMessage;
      const AMessage: string; const AExecute: TDataValidatorInformationExecute = nil);
begin
  inherited Create;

  FCustomExecute := ACustomExecute;
  FCustomMessageExecute := ACustomMessageExecute;
  FCustomMessage := ACustomMessage;

  SetMessage(AMessage);
  SetExecute(AExecute);
end;

function TValidatorCustom.Check: IDataValidatorResult;
var
  LValue: string;
  R: Boolean;
  LMessage: TDataValidatorMessage;
begin
  LValue := GetValueAsString;
  R := False;

  if Assigned(FCustomExecute) then
    R := FCustomExecute(LValue)
  else
  begin
    LMessage := GetMessage;

    if Assigned(FCustomMessageExecute) then
      R := FCustomMessageExecute(LValue, LMessage.Message)
    else
      if Assigned(FCustomMessage) then
        R := FCustomMessage(LValue, LMessage);

    SetMessage(LMessage);
  end;

  if FIsNot then
    R := not R;

  Result := TDataValidatorResult.Create(R, TDataValidatorInformation.Create(FKey, FName, LValue, GetMessage, FExecute));
end;

end.
