--Seriki Ayodele
--Computer Egineering
--Electrical and Electronics Engineering department, University of Lagos

--Computer Organisation and Architecture, CPE313
--CPE313

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity SAP1 is
  Port (    CLK: in std_logic;
            SW: in std_logic_vector (15 downto 0);
            BTN: in std_logic_vector (4 downto 0);
            LED: out std_logic_vector (15 downto 0);
            SSEG_CA: out std_logic_vector (6 downto 0);
            SSEG_AN: out std_logic_vector (3 downto 0)       
   );
end SAP1;

-- Button description

-- Clear/Reset      - BTN(0)    --Ccenter
-- Run              - SW(11) 
-- Write to RAM     - BTN(1)    --left
-- Clear RAM        - BTN(2)    --right

-- Check RAM Values - SW(10)    

-- Data             - SW (7 downto 0)
-- Address          - SW (15 downto 12)

architecture Behavioral of SAP1 is


--Some major wire signals
--signal W_bus: std_logic_vector (7 downto 0) := "11110000";
signal clockline: std_logic;

-- MAR signal
signal MAR_output: std_logic_vector (3 downto 0);

--Controller sequencer signals
signal Cp,Ep,Lm,CE, Li, Ei,La,Ea,Su,Eu,Lb,Lo, HALT: std_logic;
signal I: std_logic_vector (7 downto 4);

--RAM signals
signal RAM_address: std_logic_vector (3 downto 0);
signal RAM_clock, RAM_clear, RAM_load, RAM_store: std_logic;

signal RAM_display: std_logic_vector(7 downto 0);

--Adder subtractor signals
signal AS_accumulator, AS_b_register: std_logic_vector (7 downto 0);
signal cout: std_logic;

--Output register signal
signal OR_output: std_logic_vector (7 downto 0);

signal RAM_output: std_logic_vector (7 downto 0);

signal clock_activator: std_logic;

component welcome_display
port ( SSEG_CA: out std_logic_vector (6 downto 0);
       SSEG_AN: out std_logic_vector (3 downto 0);
       CLK: in std_logic;
       address: in std_logic_vector(3 downto 0);
       data: in std_logic_vector(7 downto 0);
       write_to_RAM: in std_logic;
       activator: in std_logic;
       OR_output: in std_logic_vector(7 downto 0);
       show_RAM_display: in std_logic;
       RAM_display: in std_logic_vector(7 downto 0));
end component;


component Mux_4bit
port (  input_1: in std_logic_vector (3 downto 0);
        input_2: in std_logic_vector (3 downto 0);
        sel:     in std_logic;
        output:  out std_logic_vector (3 downto 0));
end component;

component program_counter
port(	clock:	in std_logic; -- ~CLK
    Ep:	in std_logic;
	clear:	in std_logic; -- CLR
	count:	in std_logic; --Cp
	Q:	out std_logic_vector(3 downto 0) -- Output to bus
);
end component;

component MAR
port(	I:	in std_logic_vector(3 downto 0); -- from bus
	clock:	in std_logic;
	Lm:	in std_logic;
	clear:	in std_logic;
	Q:	out std_logic_vector(3 downto 0)
);
end component;

component RAM

port(	Clock:		in std_logic;	-- Write to RAM
        Clear:      in std_logic;   -- Clear RAM
	Enable:		in std_logic; -- Sel = 1 by default
	Read:		in std_logic; -- 
	Write:		in std_logic; -- 
	Read_Addr:	in std_logic_vector(3 downto 0);
	Write_Addr: 	in std_logic_vector(3 downto 0); 
	Data_in: 	in std_logic_vector(7 downto 0);  -- From Switches or MAR
	Data_out: 	out std_logic_vector(7 downto 0)  -- To W-Bus
	);
end component;

component instruction_register
port(	I:	in std_logic_vector(7 downto 0); --From bus
	clock:	in std_logic;   --CLK
	Li, Ei:	in std_logic; -- ~Li ~Ei
	clear:	in std_logic;   --CLR
	Qc:	out std_logic_vector(3 downto 0); -- To controller
	Qb:	out std_logic_vector(3 downto 0) --To bus
);
end component;

component controller_sequencer
port (  CLK: in std_logic;
        I: in std_logic_vector (7 downto 4);
        Cp,Ep,Lm,CE, Li, Ei,La,Ea,Su,Eu,Lb,Lo, HALT: out std_logic );
end component;

component accumulator
port(	I:	in std_logic_vector(7 downto 0);
	clock:	in std_logic;
	La, Ea:	in std_logic; -- ~La  Ea
	clear:	in std_logic;
	Qas:	out std_logic_vector(7 downto 0);  -- To addersubtractor
	Qb:	out std_logic_vector(7 downto 0)       -- TO bus
);
end component;

component adder_subtractor
port(	
        A, B: in std_logic_vector (7 downto 0); -- A is from Accumulator and B is from B reigister
        Su, Eu: in std_logic;
        Result: out std_logic_vector (7 downto 0); -- Result is To bus
        Cout: out std_logic
);
end component;

component b_register
port(	I:	in std_logic_vector(7 downto 0);
	clock:	in std_logic;   -- CLK
	 Lb:	in std_logic;   -- ~Lb
	clear:	in std_logic;   -- CLR
	Q:	out std_logic_vector(7 downto 0) -- To Add Sb
);
end component;

component output_register
port(	I:	in std_logic_vector(7 downto 0);
	clock:	in std_logic;   -- CLK
    Lo: 	in std_logic;    --  ~Lo
	clear:	in std_logic;   -- CLR
	Q:	out std_logic_vector(7 downto 0)  -- To Binary Display
);
end component;

signal W_in_MAR:    std_logic_vector (3 downto 0);
signal W_in_IR:     std_logic_vector(7 downto 0);
signal W_in_ACC:    std_logic_vector(7 downto 0);
signal W_in_BR:     std_logic_vector(7 downto 0);
signal W_in_OR:     std_logic_vector(7 downto 0);

signal W_out_PC:    std_logic_vector(3 downto 0);
signal W_out_IR:    std_logic_vector(3 downto 0);
signal W_out_RAM:   std_logic_vector(7 downto 0);
signal W_out_ACC:   std_logic_vector(7 downto 0);
signal W_out_AS:    std_logic_vector(7 downto 0);



begin

LED <= SW;

process(Ep,Lm,RAM_load, Li, Ei,La,Ea, Eu,Lb,Lo)
variable W_bus: std_logic_vector(7 downto 0);
begin

    if Ep ='1' then
        W_bus(3 downto 0) := W_out_PC;
    elsif RAM_load = '1' then
        W_bus := W_out_RAM;
    elsif Ei = '0' then
        W_bus(3 downto 0) := W_out_IR;
    elsif Ea = '1' then
        W_bus := W_out_ACC;
    elsif Eu = '1' then
        W_bus := W_out_AS;
    end if;
    
    if Lm = '0' then
        W_in_MAR <= W_bus (3 downto 0);
    end if;
    if Li = '0' then
        W_in_IR <= W_bus;
    end if;
    if La = '0' then
        W_in_ACC <= W_bus;
    end if;
    if Lb = '0' then
        W_in_BR <= W_bus;
    end if;
    if Lo = '0' then
        W_in_OR <= W_bus;
    end if;
    
end process;

SCREEN: welcome_display
    port map (SSEG_CA, SSEG_AN, CLK, SW(15 downto 12), SW(7 downto 0), RAM_clock, SW(11), OR_output, SW(10), RAM_display);

COMPONENT_0: Mux_4bit
port map (SW(15 downto 12), MAR_output, SW(11), RAM_address);

COMPONENT_1: program_counter
port map (clockline, Ep, BTN(0), Cp, W_out_PC);

COMPONENT_2: MAR
port map (W_in_MAR, clockline, Lm, BTN(0), MAR_output);

COMPONENT_3: instruction_register
port map(W_in_IR, clockline, Li, Ei, BTN (0), I, W_out_IR);

RAM_clock <= (not SW(11)) and  BTN(1);
RAM_clear <= (not SW(11)) and  BTN(2);
RAM_load <= not CE;
RAM_store <= not SW(11);

COMPONENT_4: RAM
port map(RAM_clock, RAM_clear, '1', RAM_load, RAM_store, RAM_address, RAM_address, SW(7 downto 0), W_out_RAM);

COMPONENT_4_1: RAM
port map(RAM_clock, RAM_clear, '1', '1', RAM_store, SW(15 downto 12), RAM_address, SW(7 downto 0), RAM_display);

COMPONENT_5: controller_sequencer
port map(clockline, I, Cp,Ep,Lm,CE, Li, Ei,La,Ea,Su,Eu,Lb,Lo, HALT);

COMPONENT_6: accumulator
port map (W_in_ACC, clockline, La, Ea, BTN(0), AS_accumulator , W_out_ACC);

COMPONENT_7: adder_subtractor
port map (AS_accumulator, AS_b_register, Su, Eu, W_out_AS, cout);

COMPONENT_8: b_register
port map(W_in_BR, clockline, Lb, BTN(0), AS_b_register);

OR9: output_register
port map(W_in_OR, clockline, Lo, BTN(0), OR_output);

clock_activator <= (not HALT) and SW(11);

process (HALT)
begin
    if clock_activator = '0' then
        clockline <= 'Z';
    elsif clock_activator = '1' then
        clockline <= CLK;
    end if;
end process;

end Behavioral;