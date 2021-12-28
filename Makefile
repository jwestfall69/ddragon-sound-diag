OBJS = obj/adpcm_tests.o \
       obj/ddragon_sound_diag.o \
       obj/error_addresses.o \
       obj/interrupt_handlers.o \
       obj/misc_tests.o \
       obj/misc_utils.o \
       obj/ram_tests.o \
       obj/vector_table.o \
       obj/ym2151_tests.o

INCS = include/ddragon_sound.inc include/ddragon_sound_diag.inc \
       include/error_addresses.inc include/macros.inc

VASM = vasm6809_oldstyle
VASM_FLAGS = -Fvobj -chklabels -Iinclude -quiet
VLINK = vlink
VLINK_FLAGS = -brawbin1 -Tddragon_sound_diag.ld
OUTPUT_DIR = bin
OBJ_DIR = obj
MKDIR = mkdir

$(OUTPUT_DIR)/ddragon-sound-diag.bin: $(OBJ_DIR) $(OUTPUT_DIR) $(OBJS)
	$(VLINK) $(VLINK_FLAGS) -o $(OUTPUT_DIR)/ddragon-sound-diag.bin $(OBJS)
	@echo
	@ls -l $(OUTPUT_DIR)/ddragon-sound-diag.bin

$(OBJ_DIR)/%.o: %.asm $(INCS)
	$(VASM) $(VASM_FLAGS) -o $@ $<

$(OUTPUT_DIR):
	$(MKDIR) $(OUTPUT_DIR)

$(OBJ_DIR):
	$(MKDIR) $(OBJ_DIR)

clean:
	rm -f $(OUTPUT_DIR)/ddragon-sound-diag.bin $(OBJ_DIR)/*.o

