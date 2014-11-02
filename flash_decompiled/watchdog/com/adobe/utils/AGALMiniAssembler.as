package com.adobe.utils {
    import flash.utils.*;

    public class AGALMiniAssembler {

        private static const OPMAP:Dictionary = new Dictionary();
        private static const REGMAP:Dictionary = new Dictionary();
        private static const SAMPLEMAP:Dictionary = new Dictionary();
        private static const MAX_NESTING:int = 4;
        private static const MAX_OPCODES:int = 0x0100;
        private static const FRAGMENT:String = "fragment";
        private static const VERTEX:String = "vertex";
        private static const SAMPLER_DIM_SHIFT:uint = 12;
        private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
        private static const SAMPLER_REPEAT_SHIFT:uint = 20;
        private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
        private static const SAMPLER_FILTER_SHIFT:uint = 28;
        private static const REG_WRITE:uint = 1;
        private static const REG_READ:uint = 2;
        private static const REG_FRAG:uint = 32;
        private static const REG_VERT:uint = 64;
        private static const OP_SCALAR:uint = 1;
        private static const OP_INC_NEST:uint = 2;
        private static const OP_DEC_NEST:uint = 4;
        private static const OP_SPECIAL_TEX:uint = 8;
        private static const OP_SPECIAL_MATRIX:uint = 16;
        private static const OP_FRAG_ONLY:uint = 32;
        private static const OP_NO_DEST:uint = 128;
        private static const MOV:String = "mov";
        private static const ADD:String = "add";
        private static const SUB:String = "sub";
        private static const MUL:String = "mul";
        private static const DIV:String = "div";
        private static const RCP:String = "rcp";
        private static const MIN:String = "min";
        private static const MAX:String = "max";
        private static const FRC:String = "frc";
        private static const SQT:String = "sqt";
        private static const RSQ:String = "rsq";
        private static const POW:String = "pow";
        private static const LOG:String = "log";
        private static const EXP:String = "exp";
        private static const NRM:String = "nrm";
        private static const SIN:String = "sin";
        private static const COS:String = "cos";
        private static const CRS:String = "crs";
        private static const DP3:String = "dp3";
        private static const DP4:String = "dp4";
        private static const ABS:String = "abs";
        private static const NEG:String = "neg";
        private static const SAT:String = "sat";
        private static const M33:String = "m33";
        private static const M44:String = "m44";
        private static const M34:String = "m34";
        private static const IFZ:String = "ifz";
        private static const INZ:String = "inz";
        private static const IFE:String = "ife";
        private static const INE:String = "ine";
        private static const IFG:String = "ifg";
        private static const IFL:String = "ifl";
        private static const IEG:String = "ieg";
        private static const IEL:String = "iel";
        private static const ELS:String = "els";
        private static const EIF:String = "eif";
        private static const REP:String = "rep";
        private static const ERP:String = "erp";
        private static const BRK:String = "brk";
        private static const KIL:String = "kil";
        private static const TEX:String = "tex";
        private static const SGE:String = "sge";
        private static const SLT:String = "slt";
        private static const SGN:String = "sgn";
        private static const VA:String = "va";
        private static const VC:String = "vc";
        private static const VT:String = "vt";
        private static const OP:String = "op";
        private static const V:String = "v";
        private static const FC:String = "fc";
        private static const FT:String = "ft";
        private static const FS:String = "fs";
        private static const OC:String = "oc";
        private static const D2:String = "2d";
        private static const D3:String = "3d";
        private static const CUBE:String = "cube";
        private static const MIPNEAREST:String = "mipnearest";
        private static const MIPLINEAR:String = "miplinear";
        private static const MIPNONE:String = "mipnone";
        private static const NOMIP:String = "nomip";
        private static const NEAREST:String = "nearest";
        private static const LINEAR:String = "linear";
        private static const CENTROID:String = "centroid";
        private static const SINGLE:String = "single";
        private static const DEPTH:String = "depth";
        private static const REPEAT:String = "repeat";
        private static const WRAP:String = "wrap";
        private static const CLAMP:String = "clamp";

        private static var initialized:Boolean = false;

        private var _agalcode:ByteArray = null;
        private var _error:String = "";
        private var debugEnabled:Boolean = false;

        public function AGALMiniAssembler(debugging:Boolean=false):void{
            super();
            this.debugEnabled = debugging;
            if (!(initialized)){
                init();
            };
        }
        private static function init():void{
            initialized = true;
            OPMAP[MOV] = new OpCode(MOV, 2, 0, 0);
            OPMAP[ADD] = new OpCode(ADD, 3, 1, 0);
            OPMAP[SUB] = new OpCode(SUB, 3, 2, 0);
            OPMAP[MUL] = new OpCode(MUL, 3, 3, 0);
            OPMAP[DIV] = new OpCode(DIV, 3, 4, 0);
            OPMAP[RCP] = new OpCode(RCP, 2, 5, 0);
            OPMAP[MIN] = new OpCode(MIN, 3, 6, 0);
            OPMAP[MAX] = new OpCode(MAX, 3, 7, 0);
            OPMAP[FRC] = new OpCode(FRC, 2, 8, 0);
            OPMAP[SQT] = new OpCode(SQT, 2, 9, 0);
            OPMAP[RSQ] = new OpCode(RSQ, 2, 10, 0);
            OPMAP[POW] = new OpCode(POW, 3, 11, 0);
            OPMAP[LOG] = new OpCode(LOG, 2, 12, 0);
            OPMAP[EXP] = new OpCode(EXP, 2, 13, 0);
            OPMAP[NRM] = new OpCode(NRM, 2, 14, 0);
            OPMAP[SIN] = new OpCode(SIN, 2, 15, 0);
            OPMAP[COS] = new OpCode(COS, 2, 16, 0);
            OPMAP[CRS] = new OpCode(CRS, 3, 17, 0);
            OPMAP[DP3] = new OpCode(DP3, 3, 18, 0);
            OPMAP[DP4] = new OpCode(DP4, 3, 19, 0);
            OPMAP[ABS] = new OpCode(ABS, 2, 20, 0);
            OPMAP[NEG] = new OpCode(NEG, 2, 21, 0);
            OPMAP[SAT] = new OpCode(SAT, 2, 22, 0);
            OPMAP[M33] = new OpCode(M33, 3, 23, OP_SPECIAL_MATRIX);
            OPMAP[M44] = new OpCode(M44, 3, 24, OP_SPECIAL_MATRIX);
            OPMAP[M34] = new OpCode(M34, 3, 25, OP_SPECIAL_MATRIX);
            OPMAP[IFZ] = new OpCode(IFZ, 1, 26, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[INZ] = new OpCode(INZ, 1, 27, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFE] = new OpCode(IFE, 2, 28, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[INE] = new OpCode(INE, 2, 29, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFG] = new OpCode(IFG, 2, 30, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IFL] = new OpCode(IFL, 2, 31, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IEG] = new OpCode(IEG, 2, 32, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[IEL] = new OpCode(IEL, 2, 33, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[ELS] = new OpCode(ELS, 0, 34, ((OP_NO_DEST | OP_INC_NEST) | OP_DEC_NEST));
            OPMAP[EIF] = new OpCode(EIF, 0, 35, (OP_NO_DEST | OP_DEC_NEST));
            OPMAP[REP] = new OpCode(REP, 1, 36, ((OP_NO_DEST | OP_INC_NEST) | OP_SCALAR));
            OPMAP[ERP] = new OpCode(ERP, 0, 37, (OP_NO_DEST | OP_DEC_NEST));
            OPMAP[BRK] = new OpCode(BRK, 0, 38, OP_NO_DEST);
            OPMAP[KIL] = new OpCode(KIL, 1, 39, (OP_NO_DEST | OP_FRAG_ONLY));
            OPMAP[TEX] = new OpCode(TEX, 3, 40, (OP_FRAG_ONLY | OP_SPECIAL_TEX));
            OPMAP[SGE] = new OpCode(SGE, 3, 41, 0);
            OPMAP[SLT] = new OpCode(SLT, 3, 42, 0);
            OPMAP[SGN] = new OpCode(SGN, 2, 43, 0);
            REGMAP[VA] = new Register(VA, "vertex attribute", 0, 7, (REG_VERT | REG_READ));
            REGMAP[VC] = new Register(VC, "vertex constant", 1, 127, (REG_VERT | REG_READ));
            REGMAP[VT] = new Register(VT, "vertex temporary", 2, 7, ((REG_VERT | REG_WRITE) | REG_READ));
            REGMAP[OP] = new Register(OP, "vertex output", 3, 0, (REG_VERT | REG_WRITE));
            REGMAP[V] = new Register(V, "varying", 4, 7, (((REG_VERT | REG_FRAG) | REG_READ) | REG_WRITE));
            REGMAP[FC] = new Register(FC, "fragment constant", 1, 27, (REG_FRAG | REG_READ));
            REGMAP[FT] = new Register(FT, "fragment temporary", 2, 7, ((REG_FRAG | REG_WRITE) | REG_READ));
            REGMAP[FS] = new Register(FS, "texture sampler", 5, 7, (REG_FRAG | REG_READ));
            REGMAP[OC] = new Register(OC, "fragment output", 3, 0, (REG_FRAG | REG_WRITE));
            SAMPLEMAP[D2] = new Sampler(D2, SAMPLER_DIM_SHIFT, 0);
            SAMPLEMAP[D3] = new Sampler(D3, SAMPLER_DIM_SHIFT, 2);
            SAMPLEMAP[CUBE] = new Sampler(CUBE, SAMPLER_DIM_SHIFT, 1);
            SAMPLEMAP[MIPNEAREST] = new Sampler(MIPNEAREST, SAMPLER_MIPMAP_SHIFT, 1);
            SAMPLEMAP[MIPLINEAR] = new Sampler(MIPLINEAR, SAMPLER_MIPMAP_SHIFT, 2);
            SAMPLEMAP[MIPNONE] = new Sampler(MIPNONE, SAMPLER_MIPMAP_SHIFT, 0);
            SAMPLEMAP[NOMIP] = new Sampler(NOMIP, SAMPLER_MIPMAP_SHIFT, 0);
            SAMPLEMAP[NEAREST] = new Sampler(NEAREST, SAMPLER_FILTER_SHIFT, 0);
            SAMPLEMAP[LINEAR] = new Sampler(LINEAR, SAMPLER_FILTER_SHIFT, 1);
            SAMPLEMAP[CENTROID] = new Sampler(CENTROID, SAMPLER_SPECIAL_SHIFT, (1 << 0));
            SAMPLEMAP[SINGLE] = new Sampler(SINGLE, SAMPLER_SPECIAL_SHIFT, (1 << 1));
            SAMPLEMAP[DEPTH] = new Sampler(DEPTH, SAMPLER_SPECIAL_SHIFT, (1 << 2));
            SAMPLEMAP[REPEAT] = new Sampler(REPEAT, SAMPLER_REPEAT_SHIFT, 1);
            SAMPLEMAP[WRAP] = new Sampler(WRAP, SAMPLER_REPEAT_SHIFT, 1);
            SAMPLEMAP[CLAMP] = new Sampler(CLAMP, SAMPLER_REPEAT_SHIFT, 0);
        }

        public function get error():String{
            return (this._error);
        }
        public function get agalcode():ByteArray{
            return (this._agalcode);
        }
        public function assemble(mode:String, source:String, verbose:Boolean=false):ByteArray{
            var i:int;
            var line:String;
            var startcomment:int;
            var optsi:int;
            var opts:Array;
            var opCode:Array;
            var opFound:OpCode;
            var regs:Array;
            var badreg:Boolean;
            var pad:uint;
            var regLength:uint;
            var j:int;
            var isRelative:Boolean;
            var relreg:Array;
            var res:Array;
            var regFound:Register;
            var idxmatch:Array;
            var regidx:uint;
            var regmask:uint;
            var maskmatch:Array;
            var isDest:Boolean;
            var isSampler:Boolean;
            var reltype:uint;
            var relsel:uint;
            var reloffset:int;
            var cv:uint;
            var maskLength:uint;
            var k:int;
            var relname:Array;
            var regFoundRel:Register;
            var selmatch:Array;
            var relofs:Array;
            var samplerbits:uint;
            var optsLength:uint;
            var bias:Number;
            var optfound:Sampler;
            var dbgLine:String;
            var agalLength:uint;
            var index:uint;
            var byteStr:String;
            var start:uint = getTimer();
            this._agalcode = new ByteArray();
            this._error = "";
            var isFrag:Boolean;
            if (mode == FRAGMENT){
                isFrag = true;
            } else {
                if (mode != VERTEX){
                    this._error = (((((("ERROR: mode needs to be \"" + FRAGMENT) + "\" or \"") + VERTEX) + "\" but is \"") + mode) + "\".");
                };
            };
            this.agalcode.endian = Endian.LITTLE_ENDIAN;
            this.agalcode.writeByte(160);
            this.agalcode.writeUnsignedInt(1);
            this.agalcode.writeByte(161);
            this.agalcode.writeByte(((isFrag) ? 1 : 0));
            var lines:Array = source.replace(/[\f\n\r\v]+/g, "\n").split("\n");
            var nest:int;
            var nops:int;
            var lng:int = lines.length;
            i = 0;
            while ((((i < lng)) && ((this._error == "")))) {
                line = new String(lines[i]);
                startcomment = line.search("//");
                if (startcomment != -1){
                    line = line.slice(0, startcomment);
                };
                optsi = line.search(/<.*>/g);
                if (optsi != -1){
                    opts = line.slice(optsi).match(/([\w\.\-\+]+)/gi);
                    line = line.slice(0, optsi);
                };
                opCode = line.match(/^\w{3}/ig);
                opFound = OPMAP[opCode[0]];
                if (this.debugEnabled){
                    trace(opFound);
                };
                if (opFound == null){
                    if (line.length >= 3){
                        trace(((("warning: bad line " + i) + ": ") + lines[i]));
                    };
                } else {
                    line = line.slice((line.search(opFound.name) + opFound.name.length));
                    if ((opFound.flags & OP_DEC_NEST)){
                        nest--;
                        if (nest < 0){
                            this._error = "error: conditional closes without open.";
                            break;
                        };
                    };
                    if ((opFound.flags & OP_INC_NEST)){
                        nest++;
                        if (nest > MAX_NESTING){
                            this._error = (("error: nesting to deep, maximum allowed is " + MAX_NESTING) + ".");
                            break;
                        };
                    };
                    if ((((opFound.flags & OP_FRAG_ONLY)) && (!(isFrag)))){
                        this._error = "error: opcode is only allowed in fragment programs.";
                        break;
                    };
                    if (verbose){
                        trace(("emit opcode=" + opFound));
                    };
                    this.agalcode.writeUnsignedInt(opFound.emitCode);
                    nops++;
                    if (nops > MAX_OPCODES){
                        this._error = (("error: too many opcodes. maximum is " + MAX_OPCODES) + ".");
                        break;
                    };
                    regs = line.match(/vc\[([vof][actps]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vof][actps]?)(\d*)?(\.[xyzw]{1,4})?/gi);
                    if (regs.length != opFound.numRegister){
                        this._error = (((("error: wrong number of operands. found " + regs.length) + " but expected ") + opFound.numRegister) + ".");
                        break;
                    };
                    badreg = false;
                    pad = ((64 + 64) + 32);
                    regLength = regs.length;
                    j = 0;
                    while (j < regLength) {
                        isRelative = false;
                        relreg = regs[j].match(/\[.*\]/ig);
                        if (relreg.length > 0){
                            regs[j] = regs[j].replace(relreg[0], "0");
                            if (verbose){
                                trace("IS REL");
                            };
                            isRelative = true;
                        };
                        res = regs[j].match(/^\b[A-Za-z]{1,2}/ig);
                        regFound = REGMAP[res[0]];
                        if (this.debugEnabled){
                            trace(regFound);
                        };
                        if (regFound == null){
                            this._error = (((("error: could not parse operand " + j) + " (") + regs[j]) + ").");
                            badreg = true;
                            break;
                        };
                        if (isFrag){
                            if (!((regFound.flags & REG_FRAG))){
                                this._error = (((("error: register operand " + j) + " (") + regs[j]) + ") only allowed in vertex programs.");
                                badreg = true;
                                break;
                            };
                            if (isRelative){
                                this._error = (((("error: register operand " + j) + " (") + regs[j]) + ") relative adressing not allowed in fragment programs.");
                                badreg = true;
                                break;
                            };
                        } else {
                            if (!((regFound.flags & REG_VERT))){
                                this._error = (((("error: register operand " + j) + " (") + regs[j]) + ") only allowed in fragment programs.");
                                badreg = true;
                                break;
                            };
                        };
                        regs[j] = regs[j].slice((regs[j].search(regFound.name) + regFound.name.length));
                        idxmatch = ((isRelative) ? relreg[0].match(/\d+/) : regs[j].match(/\d+/));
                        regidx = 0;
                        if (idxmatch){
                            regidx = uint(idxmatch[0]);
                        };
                        if (regFound.range < regidx){
                            this._error = (((((("error: register operand " + j) + " (") + regs[j]) + ") index exceeds limit of ") + (regFound.range + 1)) + ".");
                            badreg = true;
                            break;
                        };
                        regmask = 0;
                        maskmatch = regs[j].match(/(\.[xyzw]{1,4})/);
                        isDest = (((j == 0)) && (!((opFound.flags & OP_NO_DEST))));
                        isSampler = (((j == 2)) && ((opFound.flags & OP_SPECIAL_TEX)));
                        reltype = 0;
                        relsel = 0;
                        reloffset = 0;
                        if (((isDest) && (isRelative))){
                            this._error = "error: relative can not be destination";
                            badreg = true;
                            break;
                        };
                        if (maskmatch){
                            regmask = 0;
                            maskLength = maskmatch[0].length;
                            k = 1;
                            while (k < maskLength) {
                                cv = (maskmatch[0].charCodeAt(k) - "x".charCodeAt(0));
                                if (cv > 2){
                                    cv = 3;
                                };
                                if (isDest){
                                    regmask = (regmask | (1 << cv));
                                } else {
                                    regmask = (regmask | (cv << ((k - 1) << 1)));
                                };
                                k++;
                            };
                            if (!(isDest)){
                                while (k <= 4) {
                                    regmask = (regmask | (cv << ((k - 1) << 1)));
                                    k++;
                                };
                            };
                        } else {
                            regmask = ((isDest) ? 15 : 228);
                        };
                        if (isRelative){
                            relname = relreg[0].match(/[A-Za-z]{1,2}/ig);
                            regFoundRel = REGMAP[relname[0]];
                            if (regFoundRel == null){
                                this._error = "error: bad index register";
                                badreg = true;
                                break;
                            };
                            reltype = regFoundRel.emitCode;
                            selmatch = relreg[0].match(/(\.[xyzw]{1,1})/);
                            if (selmatch.length == 0){
                                this._error = "error: bad index register select";
                                badreg = true;
                                break;
                            };
                            relsel = (selmatch[0].charCodeAt(1) - "x".charCodeAt(0));
                            if (relsel > 2){
                                relsel = 3;
                            };
                            relofs = relreg[0].match(/\+\d{1,3}/ig);
                            if (relofs.length > 0){
                                reloffset = relofs[0];
                            };
                            if ((((reloffset < 0)) || ((reloffset > 0xFF)))){
                                this._error = (("error: index offset " + reloffset) + " out of bounds. [0..255]");
                                badreg = true;
                                break;
                            };
                            if (verbose){
                                trace(((((((((((("RELATIVE: type=" + reltype) + "==") + relname[0]) + " sel=") + relsel) + "==") + selmatch[0]) + " idx=") + regidx) + " offset=") + reloffset));
                            };
                        };
                        if (verbose){
                            trace((((((("  emit argcode=" + regFound) + "[") + regidx) + "][") + regmask) + "]"));
                        };
                        if (isDest){
                            this.agalcode.writeShort(regidx);
                            this.agalcode.writeByte(regmask);
                            this.agalcode.writeByte(regFound.emitCode);
                            pad = (pad - 32);
                        } else {
                            if (isSampler){
                                if (verbose){
                                    trace("  emit sampler");
                                };
                                samplerbits = 5;
                                optsLength = opts.length;
                                bias = 0;
                                k = 0;
                                while (k < optsLength) {
                                    if (verbose){
                                        trace(("    opt: " + opts[k]));
                                    };
                                    optfound = SAMPLEMAP[opts[k]];
                                    if (optfound == null){
                                        bias = Number(opts[k]);
                                        if (verbose){
                                            trace(("    bias: " + bias));
                                        };
                                    } else {
                                        if (optfound.flag != SAMPLER_SPECIAL_SHIFT){
                                            samplerbits = (samplerbits & ~((15 << optfound.flag)));
                                        };
                                        samplerbits = (samplerbits | (uint(optfound.mask) << uint(optfound.flag)));
                                    };
                                    k++;
                                };
                                this.agalcode.writeShort(regidx);
                                this.agalcode.writeByte(int((bias * 8)));
                                this.agalcode.writeByte(0);
                                this.agalcode.writeUnsignedInt(samplerbits);
                                if (verbose){
                                    trace(("    bits: " + (samplerbits - 5)));
                                };
                                pad = (pad - 64);
                            } else {
                                if (j == 0){
                                    this.agalcode.writeUnsignedInt(0);
                                    pad = (pad - 32);
                                };
                                this.agalcode.writeShort(regidx);
                                this.agalcode.writeByte(reloffset);
                                this.agalcode.writeByte(regmask);
                                this.agalcode.writeByte(regFound.emitCode);
                                this.agalcode.writeByte(reltype);
                                this.agalcode.writeShort(((isRelative) ? (relsel | (1 << 15)) : 0));
                                pad = (pad - 64);
                            };
                        };
                        j++;
                    };
                    j = 0;
                    while (j < pad) {
                        this.agalcode.writeByte(0);
                        j = (j + 8);
                    };
                    if (badreg){
                        break;
                    };
                };
                i++;
            };
            if (this._error != ""){
                this._error = (this._error + ((("\n  at line " + i) + " ") + lines[i]));
                this.agalcode.length = 0;
                trace(this._error);
            };
            if (this.debugEnabled){
                dbgLine = "generated bytecode:";
                agalLength = this.agalcode.length;
                index = 0;
                while (index < agalLength) {
                    if (!((index % 16))){
                        dbgLine = (dbgLine + "\n");
                    };
                    if (!((index % 4))){
                        dbgLine = (dbgLine + " ");
                    };
                    byteStr = this.agalcode[index].toString(16);
                    if (byteStr.length < 2){
                        byteStr = ("0" + byteStr);
                    };
                    dbgLine = (dbgLine + byteStr);
                    index++;
                };
                trace(dbgLine);
            };
            if (verbose){
                trace((("AGALMiniAssembler.assemble time: " + ((getTimer() - start) / 1000)) + "s"));
            };
            return (this.agalcode);
        }

    }
}//package com.adobe.utils 

class OpCode {

    private var _emitCode:uint;
    private var _flags:uint;
    private var _name:String;
    private var _numRegister:uint;

    public function OpCode(name:String, numRegister:uint, emitCode:uint, flags:uint){
        super();
        this._name = name;
        this._numRegister = numRegister;
        this._emitCode = emitCode;
        this._flags = flags;
    }
    public function get emitCode():uint{
        return (this._emitCode);
    }
    public function get flags():uint{
        return (this._flags);
    }
    public function get name():String{
        return (this._name);
    }
    public function get numRegister():uint{
        return (this._numRegister);
    }
    public function toString():String{
        return ((((((((("[OpCode name=\"" + this._name) + "\", numRegister=") + this._numRegister) + ", emitCode=") + this._emitCode) + ", flags=") + this._flags) + "]"));
    }

}
class Register {

    private var _emitCode:uint;
    private var _name:String;
    private var _longName:String;
    private var _flags:uint;
    private var _range:uint;

    public function Register(name:String, longName:String, emitCode:uint, range:uint, flags:uint){
        super();
        this._name = name;
        this._longName = longName;
        this._emitCode = emitCode;
        this._range = range;
        this._flags = flags;
    }
    public function get emitCode():uint{
        return (this._emitCode);
    }
    public function get longName():String{
        return (this._longName);
    }
    public function get name():String{
        return (this._name);
    }
    public function get flags():uint{
        return (this._flags);
    }
    public function get range():uint{
        return (this._range);
    }
    public function toString():String{
        return ((((((((((("[Register name=\"" + this._name) + "\", longName=\"") + this._longName) + "\", emitCode=") + this._emitCode) + ", range=") + this._range) + ", flags=") + this._flags) + "]"));
    }

}
class Sampler {

    private var _flag:uint;
    private var _mask:uint;
    private var _name:String;

    public function Sampler(name:String, flag:uint, mask:uint){
        super();
        this._name = name;
        this._flag = flag;
        this._mask = mask;
    }
    public function get flag():uint{
        return (this._flag);
    }
    public function get mask():uint{
        return (this._mask);
    }
    public function get name():String{
        return (this._name);
    }
    public function toString():String{
        return ((((((("[Sampler name=\"" + this._name) + "\", flag=\"") + this._flag) + "\", mask=") + this.mask) + "]"));
    }

}
