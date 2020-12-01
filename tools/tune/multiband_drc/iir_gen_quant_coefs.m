function [emp_coefs, deemp_coefs] = iir_gen_quant_coefs(params);

stage_gain = params.stage_gain;
stage_ratio = params.stage_ratio;
anchor_freq = params.anchor;

emp = cell(1, 2);
deemp = cell(1, 2);
% Generate the coefficients of (de)emphasis for the 1-st stage of biquads
[emp(1), deemp(1)] = emp_deemp_stage_biquad(stage_gain, anchor_freq,
					    anchor_freq / stage_ratio);

anchor_freq = anchor_freq / (stage_ratio * stage_ratio);

% Generate the coefficients of (de)emphasis for the 2-nd stage of biquads
[emp(2), deemp(2)] = emp_deemp_stage_biquad(stage_gain, anchor_freq,
                                            anchor_freq / stage_ratio);

% Print emp and deemp
emp
deemp

% Convert the coefficients to values usable with SOF
emp_coefs = iir_coef_quant(emp);
deemp_coefs = iir_coef_quant(deemp);

end

function [emp, deemp] = emp_deemp_stage_biquad(gain, f1, f2);

[z1, p1] = emp_stage_roots(gain, f1);
[z2, p2] = emp_stage_roots(gain, f2);

b0 = 1;
b1 = -(z1 + z2);
b2 = z1 * z2;
a0 = 1;
a1 = -(p1 + p2);
a2 = p1 * p2;

% Gain compensation to make 0dB at 0Hz
alpha = (a0 + a1 + a2) / (b0 + b1 + b2);
[rshift, gain] = decompose_gain(alpha);

%     [a2  a1  b2  b1  b0  shift   gain]
emp = [-a2, -a1, b2, b1, b0, rshift, gain];

beta = (b0 + b1 + b2) / (a0 + a1 + a2);
[rshift, gain] = decompose_gain(beta);

%       [a2  a1  b2  b1  b0  shift   gain]
deemp = [-b2, -b1, a2, a1, a0, rshift, gain];

end

function [zero, pole] = emp_stage_roots(gain, normalized_freq);

gk = 1 - gain / 20;
f1 = normalized_freq * gk;
f2 = normalized_freq / gk;
zero = exp(-f1 * pi);
pole = exp(-f2 * pi);

end

function quant_coefs = iir_coef_quant(coefs);

bits_iir = 32; % Q2.30
qf_iir = 30;

bits_gain = 16; % Q2.14
qf_gain = 14;

addpath ./../eq

quant_coefs = cell(1, 2);
for i = 1:length(coefs)
	coef = cell2mat(coefs(i));
	quant_ab = eq_coef_quant(coef(1:5), bits_iir, qf_iir);
	quant_gain = eq_coef_quant(coef(7), bits_gain, qf_gain);
	quant_coefs(i) = [quant_ab coef(6) quant_gain];
end

quant_coefs = cell2mat(quant_coefs);

rmpath ./../eq

end

function [rshift, gain] = decompose_gain(prev_gain);

max_abs_val = 2; % Q2.14
rshift = 0;
gain = prev_gain;

while (abs(gain) >= max_abs_val)
	gain = gain / 2;
	rshift--; % left-shift in shift stage
endwhile

end
