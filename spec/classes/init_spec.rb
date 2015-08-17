require 'spec_helper'

describe 'nzbget' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge!(:concat_basedir => '/dne')
        end

        context "nzbget class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('nzbget') \
            .that_requires('nzbget::service') }
          it { is_expected.to contain_class('nzbget::params') }
          it { is_expected.to contain_class('nzbget::install') \
            .that_comes_before('nzbget::config') }
          it { is_expected.to contain_class('nzbget::config') }
          it { is_expected.to contain_class('nzbget::service') \
            .that_subscribes_to('nzbget::config') }

          it { is_expected.to contain_wget__fetch('nzbget download') \
            .that_comes_before('Exec[nzbget install]') }
          it { is_expected.to contain_exec('nzbget install') }
          it { is_expected.to contain_user('nzbget') }

          it { is_expected.to contain_file('/srv/nzbget') \
            .that_comes_before('Concat[/srv/nzbget/nzbget.conf]') }
          it { is_expected.to contain_concat('/srv/nzbget/nzbget.conf') }
          it { is_expected.to contain_concat__fragment('categories') }
          it { is_expected.to contain_concat__fragment('display') }
          it { is_expected.to contain_concat__fragment('download') }
          it { is_expected.to contain_concat__fragment('extension') }
          it { is_expected.to contain_concat__fragment('incoming') }
          it { is_expected.to contain_concat__fragment('logging') }
          it { is_expected.to contain_concat__fragment('par') }
          it { is_expected.to contain_concat__fragment('paths') }
          it { is_expected.to contain_concat__fragment('rss') }
          it { is_expected.to contain_concat__fragment('scheduler') }
          it { is_expected.to contain_concat__fragment('security') }
          it { is_expected.to contain_concat__fragment('servers') }
          it { is_expected.to contain_concat__fragment('unpack') }

          it { is_expected.to contain_service('nzbget') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'nzbget class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('nzbget') } \
        .to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
