(*%****************************************************************************
 *  ___                                             ___               _       *
 * / __|  ___   _ __    _ __   __ _   _ _   ___    | _ )  ___   ___  | |_     *
 * \__ \ / -_) | '  \  | '_ \ / _` | | '_| / -_)   | _ \ / _ \ / _ \ |  _|    *
 * |___/ \___| |_|_|_| | .__/ \__,_| |_|   \___|   |___/ \___/ \___/  \__|    *
 *                     |_|                                                    *
 ******************************************************************************
 *                                                                            *
 *                        VELOCITY TEMPLATE ENGINE                            *
 *                                                                            *
 *                                                                            *
 *          https://www.github.com/sempare/sempare.boot.velocity.oss          *
 ******************************************************************************
 *                                                                            *
 * Copyright (c) 2019 Sempare Limited,                                        *
 *                    Conrad Vermeulen <conrad.vermeulen@gmail.com>           *
 *                                                                            *
 * Contact: info@sempare.ltd                                                  *
 *                                                                            *
 * Licensed under the Apache License, Version 2.0 (the "License");            *
 * you may not use this file except in compliance with the License.           *
 * You may obtain a copy of the License at                                    *
 *                                                                            *
 *   http://www.apache.org/licenses/LICENSE-2.0                               *
 *                                                                            *
 * Unless required by applicable law or agreed to in writing, software        *
 * distributed under the License is distributed on an "AS IS" BASIS,          *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   *
 * See the License for the specific language governing permissions and        *
 * limitations under the License.                                             *
 *                                                                            *
 ****************************************************************************%*)
unit Sempare.Boot.Template.Velocity.Component.Engine;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Rtti,
  Sempare.Boot.Template.Velocity.Component.Context,
  Sempare.Boot.Template.Velocity.Component.Template,
  Sempare.Boot.Template.Velocity;

type

  [ObservableMember('Text')]
  TSempareBootVelocityEngine = class(TComponent)
  private
    FContext: TSempareBootVelocityContext;
    FTemplate: TSempareBootVelocityTemplate;
    FVariables: TDictionary<string, TValue>;
    FText: string;
    FEnabled: boolean;
    procedure SetContext(const Value: TSempareBootVelocityContext);
    procedure SetTemplate(const Value: TSempareBootVelocityTemplate);
    procedure SetVariables(const Value: TDictionary<string, TValue>);
    procedure Evaluate;
    function GetText: string;
    procedure SetEnabled(const Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
  published
    property Text: string read GetText;
    property Enabled: boolean read FEnabled write SetEnabled;
    property Context: TSempareBootVelocityContext read FContext write SetContext;
    property Template: TSempareBootVelocityTemplate read FTemplate write SetTemplate;
    property Variables: TDictionary<string, TValue> read FVariables write SetVariables;
  end;

implementation

uses
  Sempare.Boot.Template.Velocity.Context;

{ TSempareBootVelocityEngine }

procedure TSempareBootVelocityEngine.Clear;
begin
  FText := '';
end;

constructor TSempareBootVelocityEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVariables := TDictionary<string, TValue>.Create;
end;

destructor TSempareBootVelocityEngine.Destroy;
begin
  FVariables.Free;
  inherited;
end;

procedure TSempareBootVelocityEngine.Evaluate;
var
  ctx: IVelocityContext;
begin
  if not FEnabled then
    exit;
  if FTemplate <> nil then
  begin
    if FContext <> nil then
      ctx := FContext.Context
    else
      ctx := Velocity.Context();

    FText := Velocity.Eval(ctx, FTemplate.Template, FVariables);
  end;
end;

function TSempareBootVelocityEngine.GetText: string;
begin
  result := FText;
end;

procedure TSempareBootVelocityEngine.SetContext(const Value: TSempareBootVelocityContext);
begin
  FContext := Value;
  Evaluate;
end;

procedure TSempareBootVelocityEngine.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
  if Value then
    FTemplate.Enabled := true;
  Evaluate;
end;

procedure TSempareBootVelocityEngine.SetTemplate(const Value: TSempareBootVelocityTemplate);
begin
  FTemplate := Value;
  Evaluate;
end;

procedure TSempareBootVelocityEngine.SetVariables(const Value: TDictionary<string, TValue>);
begin
  FVariables := Value;
  Evaluate;
end;

end.