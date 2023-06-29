do
	local COMMAND = {}
	COMMAND.description = "Stops controlling a Combine Scanner."
	
	function COMMAND:OnRun(client, arguments)
		if client:IsPilotScanner() then
			local scanner = client:GetPilotingScanner()
			
			scanner:Eject()

			SafeRemoveEntity(scanner)
		end
	end

	ix.command.Add("ScannerEject", COMMAND)
end