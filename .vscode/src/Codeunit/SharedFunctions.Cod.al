codeunit 50101 "Shared Functions"
{
    trigger OnRun()
    var
        UserPersonalization: Record "User Personalization";
        SessionSetting: SessionSettings;
    begin
        if UserPersonalization.Get(UserSecurityId()) then begin
            SessionSetting.Init();
            if UserPersonalization."Language ID" = 1031 then begin
                UserPersonalization.Validate("Language ID", 1033);
            end else begin
                UserPersonalization.Validate("Language ID", 1031);
            end;
            SessionSetting.Init();
            SessionSetting.LanguageId := UserPersonalization."Language ID";
            UserPersonalization.Modify(true);
            SessionSetting.RequestSessionUpdate(true);
        end;
    end;
}