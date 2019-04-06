library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.NUMERIC_STD.all;

entity ALU is

  generic (
     constant N: natural := 1  -- number of shited or rotated bits
  );

  Port (
    A, B     : in  STD_LOGIC_VECTOR(31 downto 0);  -- 2 inputs 32-bit
    ALU_Sel  : in  STD_LOGIC_VECTOR(3 downto 0);  -- 1 input 4-bit for selecting function
    ALU_Out   : out  STD_LOGIC_VECTOR(31 downto 0); -- 1 output 32-bit
    Carryout : out std_logic;        -- Carryout flag
    Hi, Lo : out std_logic_vector(31 downto 0); -- Hi Lo outputs 32-bits
    Zero : out STD_LOGIC -- Zero flag
  );

end ALU;

architecture Behavioral of ALU is

signal ALU_Result64 : std_logic_vector (63 downto 0);
signal ALU_Result : std_logic_vector (32 downto 0);

begin
   process(A,B,ALU_Sel)

 begin

  ALU_Result64 <= x"0000000000000000";
  
  case(ALU_Sel) is
  when "0000" => -- Addition
   ALU_Result <= ('0' & A) + ('0' & B) ;

  when "0001" => -- Subtraction
   ALU_Result <= ('0' & A) - ('0' & B) ;

  when "0010" => -- Multiplication
   ALU_Result64 <= A * B ;
   ALU_Result <= ALU_Result64(32 downto 0);

  when "0100" => -- Logical shift left
   ALU_Result <= ('0' & A) sll N ;

  when "0101" => -- Logical shift right
   ALU_Result <= ('0' & A) srl N ;

  when "0110" => -- Arithmetic shift left
   ALU_Result <= ('0' & A) rol N ; --TO-DO

  when "0111" => -- Arithmetic shift right
   ALU_Result <= ('0' & A) ror N ; --TO-DO

  when "1000" => -- Logical and
   ALU_Result <= '0' & (A and B);

  when "1001" => -- Logical or
   ALU_Result <= '0' & (A or B);

  when "1010" => -- Logical xor
   ALU_Result <= '0' & (A xor B);

  when "1011" => -- Logical nor
   ALU_Result <= '0' & (A nor B);

  when "1100" => -- Logical nand
   ALU_Result <= '0' & (A nand B);

  when "1101" => -- Logical xnor
   ALU_Result <= '0' & (A xnor B);

  when "1110" => -- Greater comparison
   if(A>B) then
    ALU_Result <= "000000000000000000000000000000001" ;
   else
    ALU_Result <= "000000000000000000000000000000000" ;
   end if;

  when "1111" => -- Equal comparison
   if(A=B) then
    ALU_Result <= "000000000000000000000000000000001" ;
   else
    ALU_Result <= "000000000000000000000000000000000" ;
   end if;
  when others => null;

  end case;
 end process;
 Hi <= x"00000000" when (ALU_Result64(63 downto 32) = X"00000000") else ALU_Result64(63 downto 32); -- Hi out
 Lo <= x"00000000" when (ALU_Result64(31 downto 0 ) = X"00000000") else ALU_Result64(31 downto 0); -- Lo out

 ALU_Out <= ALU_Result(31 downto 0) when (Lo(31 downto 0) = x"00000000") else Lo(31 downto 0); -- ALU out
 Carryout <= ALU_Result(32); -- Carryout flag
 Zero <= '1' when (ALU_Result(31 downto 0)) = x"00000000" and (Hi(31 downto 0 ) = x"00000000") else '0'; --Zero flag

end Behavioral;
