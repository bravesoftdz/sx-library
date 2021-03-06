unit uStart;

interface

uses uTypes, uDIniFile;

function GetRunCount: UG;
function RunFirstTime: BG;
function GetRunTime: U8;
function GetStartProgramTime: UG;
procedure RWStart(const MainIni: TDIniFile; const Save: BG);

implementation

uses
	uSimulation, uFile, uProjectInfo,
	Windows;

var
	LastProductVersion: string;
	GRunCount: UG;
	GRunTime: U8;
	GStartProgramTime: U4;

	GRunProgramTime: U8;

function GetRunCount: UG;
begin
	Result := GRunCount;
end;

function RunFirstTime: BG;
begin
	Assert(GRunCount > 0);
	Result := GRunCount <= 1;
end;

function GetRunTime: U8;
begin
	Result := GRunTime;
end;

function GetStartProgramTime: UG;
begin
	Result := GStartProgramTime;
end;

procedure RWStart(const MainIni: TDIniFile; const Save: BG);
const
	Section = 'Statistics';
begin
	if Save then
		GRunTime := U8(TimeDifference(GetTickCount, GStartProgramTime)) + GRunProgramTime;

	if Assigned(MainIni) then
	begin
		if Save then
			LastProductVersion := GetProjectInfo(piProductVersion)
		else
			LastProductVersion := '';
		LocalMainIni.RWString(Section, 'Version', LastProductVersion, Save);
		LocalMainIni.RWNum(Section, 'RunCount', GRunCount, Save);
		LocalMainIni.RWNum(Section, 'RunTime', GRunTime, Save);
		LocalMainIni.RWNum(Section, 'ReadCount', ReadCount, Save);
		LocalMainIni.RWNum(Section, 'ReadBytes', ReadBytes, Save);
		LocalMainIni.RWNum(Section, 'WriteCount', WriteCount, Save);
		LocalMainIni.RWNum(Section, 'WriteBytes', WriteBytes, Save);
		if Save = False then
		begin
			Inc(GRunCount);
//			StartProgramTime := GetTickCount;
			GRunProgramTime := GRunTime;
		end;
	end;
end;

initialization
{$IFNDEF NoInitialization}
	GStartProgramTime := GetTickCount;
{$ENDIF NoInitialization}
end.

