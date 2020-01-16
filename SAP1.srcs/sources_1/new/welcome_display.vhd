library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity welcome_display is
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
end welcome_display;

architecture Behavioral of welcome_display is
signal countM: STD_LOGIC_VECTOR (30 downto 0);
signal selectorM: std_logic_vector(1 downto 0);
signal selectorMS: std_logic_vector(3 downto 0);

signal OR_output_digit: std_logic_vector(3 downto 0);

begin
process(CLK, activator)
begin 
    if(rising_edge(CLK)) then
        countM <= countM + "1";
    end if;
end process;

selectorM <= countM(19 downto 18);
selectorMS <= countM(29 downto 26);

process(selectorM, selectorMS, activator, OR_output, write_to_RAM, address, data, RAM_display, show_RAM_display)
begin

if activator = '0' then
    if show_RAM_display = '0' then
    
        if write_to_RAM = '1' then
            case selectorM is
                when "00" =>
                SSEG_AN <= "0111";
                case address(3 downto 0) is
                    when "0000" => SSEG_CA <= "1000000"; -- "0"     
                    when "0001" => SSEG_CA <= "1111001"; -- "1" 
                    when "0010" => SSEG_CA <= "0100100"; -- "2" 
                    when "0011" => SSEG_CA <= "0110000"; -- "3" 
                    when "0100" => SSEG_CA <= "0011001"; -- "4" 
                    when "0101" => SSEG_CA <= "0010010"; -- "5" 
                    when "0110" => SSEG_CA <= "0000010"; -- "6" 
                    when "0111" => SSEG_CA <= "1111000"; -- "7" 
                    when "1000" => SSEG_CA <= "0000000"; -- "8"     
                    when "1001" => SSEG_CA <= "0010000"; -- "9" 
                    when "1010" => SSEG_CA <= "0100000"; -- a
                    when "1011" => SSEG_CA <= "0000011"; -- b
                    when "1100" => SSEG_CA <= "1000110"; -- C
                    when "1101" => SSEG_CA <= "0100001"; -- d
                    when "1110" => SSEG_CA <= "0000110"; -- E
                    when "1111" => SSEG_CA <= "0001110"; -- F
                end case;
                when "01" =>
                SSEG_AN <= "1011";
                SSEG_CA <= "1111111";
                when "10" =>
                SSEG_AN <= "1101";
                case data(7 downto 4) is
                    when "0000" => SSEG_CA <= "1000000"; -- "0"     
                    when "0001" => SSEG_CA <= "1111001"; -- "1" 
                    when "0010" => SSEG_CA <= "0100100"; -- "2" 
                    when "0011" => SSEG_CA <= "0110000"; -- "3" 
                    when "0100" => SSEG_CA <= "0011001"; -- "4" 
                    when "0101" => SSEG_CA <= "0010010"; -- "5" 
                    when "0110" => SSEG_CA <= "0000010"; -- "6" 
                    when "0111" => SSEG_CA <= "1111000"; -- "7" 
                    when "1000" => SSEG_CA <= "0000000"; -- "8"     
                    when "1001" => SSEG_CA <= "0010000"; -- "9" 
                    when "1010" => SSEG_CA <= "0100000"; -- a
                    when "1011" => SSEG_CA <= "0000011"; -- b
                    when "1100" => SSEG_CA <= "1000110"; -- C
                    when "1101" => SSEG_CA <= "0100001"; -- d
                    when "1110" => SSEG_CA <= "0000110"; -- E
                    when "1111" => SSEG_CA <= "0001110"; -- F
                end case;
                when "11" =>
                SSEG_AN <= "1110";
                case data(3 downto 0) is
                    when "0000" => SSEG_CA <= "1000000"; -- "0"     
                    when "0001" => SSEG_CA <= "1111001"; -- "1" 
                    when "0010" => SSEG_CA <= "0100100"; -- "2" 
                    when "0011" => SSEG_CA <= "0110000"; -- "3" 
                    when "0100" => SSEG_CA <= "0011001"; -- "4" 
                    when "0101" => SSEG_CA <= "0010010"; -- "5" 
                    when "0110" => SSEG_CA <= "0000010"; -- "6" 
                    when "0111" => SSEG_CA <= "1111000"; -- "7" 
                    when "1000" => SSEG_CA <= "0000000"; -- "8"     
                    when "1001" => SSEG_CA <= "0010000"; -- "9" 
                    when "1010" => SSEG_CA <= "0100000"; -- a
                    when "1011" => SSEG_CA <= "0000011"; -- b
                    when "1100" => SSEG_CA <= "1000110"; -- C
                    when "1101" => SSEG_CA <= "0100001"; -- d
                    when "1110" => SSEG_CA <= "0000110"; -- E
                    when "1111" => SSEG_CA <= "0001110"; -- F
                end case;
            end case;
        else
            case selectorM is
            when "00" =>
                SSEG_AN <= "0111"; 
                case selectorMS is
                    when "0000" =>
                        SSEG_CA <= "1111111";   -- ' '
                    when "0001" =>
                        SSEG_CA <= "1000110";   -- 'C'
                    when "0010" =>
                        SSEG_CA <= "0001100";   -- 'P'
                    when "0011" =>
                        SSEG_CA <= "0000110";   -- 'E'
                    when "0100" =>
                        SSEG_CA <= "0110000";   -- '3'
                    when "0101" =>
                        SSEG_CA <= "1111001";   -- '1'
                    when "0110" =>
                        SSEG_CA <= "0110000";   -- '3'
                    when "0111" =>
                        SSEG_CA <= "1111111";   -- ' '
                    when "1000" =>
                        SSEG_CA <= "0010010";   -- 'S'
                    when "1001" =>
                        SSEG_CA <= "0001000";   -- 'A'
                    when "1010" =>
                        SSEG_CA <= "0001100";   -- 'P'
                    when "1011" =>
                        SSEG_CA <= "1111001";   -- '1'
                    when "1100" =>
                        SSEG_CA <= "1111111";   -- ' '
                    when "1101" =>
                        SSEG_CA <= "0010000";   -- 'g'
                    when "1110" =>
                        SSEG_CA <= "0010010";   -- '5'
                    when "1111" =>
                        SSEG_CA <= "1111111";   -- ' '
                end case;
            when "01" =>
                SSEG_AN <= "1011"; 
                case selectorMS is
                    when "0000" =>
                        SSEG_CA <= "1000110";
                    when "0001" =>
                        SSEG_CA <= "0001100";
                    when "0010" =>
                        SSEG_CA <= "0000110";
                    when "0011" =>
                        SSEG_CA <= "0110000";
                    when "0100" =>
                        SSEG_CA <= "1111001";
                    when "0101" =>
                        SSEG_CA <= "0110000";
                    when "0110" =>
                        SSEG_CA <= "1111111";
                    when "0111" =>
                        SSEG_CA <= "0010010";
                    when "1000" =>
                        SSEG_CA <= "0001000";
                    when "1001" =>
                        SSEG_CA <= "0001100";
                    when "1010" =>
                        SSEG_CA <= "1111001";
                    when "1011" =>
                        SSEG_CA <= "1111111";
                    when "1100" =>
                        SSEG_CA <= "0010000";
                    when "1101" =>
                        SSEG_CA <= "0010010";
                    when "1110" =>
                        SSEG_CA <= "1111111";
                    when "1111" =>
                        SSEG_CA <= "1111111";
                end case;
            when "10" =>
                SSEG_AN <= "1101";
                case selectorMS is
                    when "0000" =>
                        SSEG_CA <= "0001100";
                    when "0001" =>
                        SSEG_CA <= "0000110";
                    when "0010" =>
                        SSEG_CA <= "0110000";
                    when "0011" =>
                        SSEG_CA <= "1111001";
                    when "0100" =>
                        SSEG_CA <= "0110000";
                    when "0101" =>
                        SSEG_CA <= "1111111";
                    when "0110" =>
                        SSEG_CA <= "0010010";
                    when "0111" =>
                        SSEG_CA <= "0001000";
                    when "1000" =>
                        SSEG_CA <= "0001100";
                    when "1001" =>
                        SSEG_CA <= "1111001";
                    when "1010" =>
                        SSEG_CA <= "1111111";
                    when "1011" =>
                        SSEG_CA <= "0010000";
                    when "1100" =>
                        SSEG_CA <= "0010010";
                    when "1101" =>
                        SSEG_CA <= "1111111";
                    when "1110" =>
                        SSEG_CA <= "1111111";
                    when "1111" =>
                        SSEG_CA <= "1000110";
                end case;
            when "11" =>
                SSEG_AN <= "1110";
                case selectorMS is
                    when "0000" =>
                        SSEG_CA <= "0000110";
                    when "0001" =>
                        SSEG_CA <= "0110000";
                    when "0010" =>
                        SSEG_CA <= "1111001";
                    when "0011" =>
                        SSEG_CA <= "0110000";
                    when "0100" =>
                        SSEG_CA <= "1111111";
                    when "0101" =>
                        SSEG_CA <= "0010010";
                    when "0110" =>
                        SSEG_CA <= "0001000";
                    when "0111" =>
                        SSEG_CA <= "0001100";
                    when "1000" =>
                        SSEG_CA <= "1111001";
                    when "1001" =>
                        SSEG_CA <= "1111111";
                    when "1010" =>
                        SSEG_CA <= "0010000";
                    when "1011" =>
                        SSEG_CA <= "0010010";
                    when "1100" =>
                        SSEG_CA <= "1111111";
                    when "1101" =>
                        SSEG_CA <= "1111111";
                    when "1110" =>
                        SSEG_CA <= "1000110";
                    when "1111" =>
                        SSEG_CA <= "0001100";
                end case;
            end case;
        end if;
        
    else
        case selectorM is
                when "00" =>
                SSEG_AN <= "0111";
                case address(3 downto 0) is
                    when "0000" => SSEG_CA <= "1000000"; -- "0"     
                    when "0001" => SSEG_CA <= "1111001"; -- "1" 
                    when "0010" => SSEG_CA <= "0100100"; -- "2" 
                    when "0011" => SSEG_CA <= "0110000"; -- "3" 
                    when "0100" => SSEG_CA <= "0011001"; -- "4" 
                    when "0101" => SSEG_CA <= "0010010"; -- "5" 
                    when "0110" => SSEG_CA <= "0000010"; -- "6" 
                    when "0111" => SSEG_CA <= "1111000"; -- "7" 
                    when "1000" => SSEG_CA <= "0000000"; -- "8"     
                    when "1001" => SSEG_CA <= "0010000"; -- "9" 
                    when "1010" => SSEG_CA <= "0100000"; -- a
                    when "1011" => SSEG_CA <= "0000011"; -- b
                    when "1100" => SSEG_CA <= "1000110"; -- C
                    when "1101" => SSEG_CA <= "0100001"; -- d
                    when "1110" => SSEG_CA <= "0000110"; -- E
                    when "1111" => SSEG_CA <= "0001110"; -- F
                end case;
                when "01" =>
                SSEG_AN <= "1011";
                SSEG_CA <= "1111111";
                when "10" =>
                SSEG_AN <= "1101";
                case RAM_display(7 downto 4) is
                    when "0000" => SSEG_CA <= "1000000"; -- "0"     
                    when "0001" => SSEG_CA <= "1111001"; -- "1" 
                    when "0010" => SSEG_CA <= "0100100"; -- "2" 
                    when "0011" => SSEG_CA <= "0110000"; -- "3" 
                    when "0100" => SSEG_CA <= "0011001"; -- "4" 
                    when "0101" => SSEG_CA <= "0010010"; -- "5" 
                    when "0110" => SSEG_CA <= "0000010"; -- "6" 
                    when "0111" => SSEG_CA <= "1111000"; -- "7" 
                    when "1000" => SSEG_CA <= "0000000"; -- "8"     
                    when "1001" => SSEG_CA <= "0010000"; -- "9" 
                    when "1010" => SSEG_CA <= "0100000"; -- a
                    when "1011" => SSEG_CA <= "0000011"; -- b
                    when "1100" => SSEG_CA <= "1000110"; -- C
                    when "1101" => SSEG_CA <= "0100001"; -- d
                    when "1110" => SSEG_CA <= "0000110"; -- E
                    when "1111" => SSEG_CA <= "0001110"; -- F
                end case;
                when "11" =>
                SSEG_AN <= "1110";
                case RAM_display(3 downto 0) is
                    when "0000" => SSEG_CA <= "1000000"; -- "0"     
                    when "0001" => SSEG_CA <= "1111001"; -- "1" 
                    when "0010" => SSEG_CA <= "0100100"; -- "2" 
                    when "0011" => SSEG_CA <= "0110000"; -- "3" 
                    when "0100" => SSEG_CA <= "0011001"; -- "4" 
                    when "0101" => SSEG_CA <= "0010010"; -- "5" 
                    when "0110" => SSEG_CA <= "0000010"; -- "6" 
                    when "0111" => SSEG_CA <= "1111000"; -- "7" 
                    when "1000" => SSEG_CA <= "0000000"; -- "8"     
                    when "1001" => SSEG_CA <= "0010000"; -- "9" 
                    when "1010" => SSEG_CA <= "0100000"; -- a
                    when "1011" => SSEG_CA <= "0000011"; -- b
                    when "1100" => SSEG_CA <= "1000110"; -- C
                    when "1101" => SSEG_CA <= "0100001"; -- d
                    when "1110" => SSEG_CA <= "0000110"; -- E
                    when "1111" => SSEG_CA <= "0001110"; -- F
                end case;
            end case;
    end if;
else
    --Program is running--
    --Try something else
    case selectorM is
    when "00" =>
        SSEG_AN <= "0111"; 
        SSEG_CA <= "1111111";
    when "01" =>
        SSEG_AN <= "1011"; 
        SSEG_CA <= "1111111";
    when "10" =>
        SSEG_AN <= "1101"; 
        --SSEG_CA <= "1000000";
        case OR_output(7 downto 4) is
            when "0000" => SSEG_CA <= "1000000"; -- "0"     
            when "0001" => SSEG_CA <= "1111001"; -- "1" 
            when "0010" => SSEG_CA <= "0100100"; -- "2" 
            when "0011" => SSEG_CA <= "0110000"; -- "3" 
            when "0100" => SSEG_CA <= "0011001"; -- "4" 
            when "0101" => SSEG_CA <= "0010010"; -- "5" 
            when "0110" => SSEG_CA <= "0000010"; -- "6" 
            when "0111" => SSEG_CA <= "1111000"; -- "7" 
            when "1000" => SSEG_CA <= "0000000"; -- "8"     
            when "1001" => SSEG_CA <= "0010000"; -- "9" 
            when "1010" => SSEG_CA <= "0100000"; -- a
            when "1011" => SSEG_CA <= "0000011"; -- b
            when "1100" => SSEG_CA <= "1000110"; -- C
            when "1101" => SSEG_CA <= "0100001"; -- d
            when "1110" => SSEG_CA <= "0000110"; -- E
            when "1111" => SSEG_CA <= "0001110"; -- F
        end case;
    when "11" =>
        SSEG_AN <= "1110";
        --SSEG_CA <= "1000000";
        case OR_output(3 downto 0) is
            when "0000" => SSEG_CA <= "1000000"; -- "0"     
            when "0001" => SSEG_CA <= "1111001"; -- "1" 
            when "0010" => SSEG_CA <= "0100100"; -- "2" 
            when "0011" => SSEG_CA <= "0110000"; -- "3" 
            when "0100" => SSEG_CA <= "0011001"; -- "4" 
            when "0101" => SSEG_CA <= "0010010"; -- "5" 
            when "0110" => SSEG_CA <= "0000010"; -- "6" 
            when "0111" => SSEG_CA <= "1111000"; -- "7" 
            when "1000" => SSEG_CA <= "0000000"; -- "8"     
            when "1001" => SSEG_CA <= "0010000"; -- "9" 
            when "1010" => SSEG_CA <= "0100000"; -- a
            when "1011" => SSEG_CA <= "0000011"; -- b
            when "1100" => SSEG_CA <= "1000110"; -- C
            when "1101" => SSEG_CA <= "0100001"; -- d
            when "1110" => SSEG_CA <= "0000110"; -- E
            when "1111" => SSEG_CA <= "0001110"; -- F
        end case;
end case;
end if;
end process;



end Behavioral;
